Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752658AbaKZOGB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 09:06:01 -0500
Received: from senator.holtmann.net ([87.106.208.187]:55644 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbaKZOF6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 09:05:58 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: bluetooth related firmware loader spew on resume.
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1416996623.3171.7.camel@linux-0dmf.site>
Date: Wed, 26 Nov 2014 23:05:20 +0900
Cc: Takashi Iwai <tiwai@suse.de>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, pgynther@google.com,
        linux-bluetooth@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <0E1D95E7-64D2-4BEA-AFAA-4B119838F24E@holtmann.org>
References: <20141111181228.GA27815@redhat.com> <s5hsih7xmgg.wl-tiwai@suse.de> <D19A9DA1-3706-4351-B2E9-25D5ABA662E7@holtmann.org> <s5h7fyijqc9.wl-tiwai@suse.de> <1416996623.3171.7.camel@linux-0dmf.site>
To: Oliver Neukum <oneukum@suse.de>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

>> In order to paper over this, we may also remember the failing firmware
>> and avoid loading it.  This might be an easer way than the endless
>> fight against UMH race...
> 
> 
> the full fix would be to implement reset_resume() for btusb.
> It seems to me that setup() should be split in two methods,
> one to request the firmware from user space and the second
> to transfer it to the device. reset_resume() would just need
> to repeat the second operation.

so when you do hci_register_dev, then hdev->setup is only called once. I really mean only once per lifetime of the hci_dev. So you would need to unregister the hci_dev first before hdev->setup will ever be called again. So I am not sure this is actually the problem here. The problem here is entirely within request_firmware() unless of course we run through the USB probe handlers again. Which I do not see happening here.

And we have hdev->setup this way since normally the Bluetooth devices keep their firmware patches and not forget about them and suspend-resume cycles. If the USB device of course jumps of the bus during it then all bets are off anyway.

Regards

Marcel

