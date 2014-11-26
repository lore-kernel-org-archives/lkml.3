Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442AbaKZKK1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:10:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35523 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbaKZKKZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:10:25 -0500
Message-ID: <1416996623.3171.7.camel@linux-0dmf.site>
Subject: Re: bluetooth related firmware loader spew on resume.
From: Oliver Neukum <oneukum@suse.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Marcel Holtmann <marcel@holtmann.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, pgynther@google.com,
        linux-bluetooth@vger.kernel.org
Date: Wed, 26 Nov 2014 11:10:23 +0100
In-Reply-To: <s5h7fyijqc9.wl-tiwai@suse.de>
References: <20141111181228.GA27815@redhat.com>
	 <s5hsih7xmgg.wl-tiwai@suse.de>
	 <D19A9DA1-3706-4351-B2E9-25D5ABA662E7@holtmann.org>
	 <s5h7fyijqc9.wl-tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-26 at 09:52 +0100, Takashi Iwai wrote:
> At Wed, 26 Nov 2014 14:15:27 +0900,

> In order to paper over this, we may also remember the failing firmware
> and avoid loading it.  This might be an easer way than the endless
> fight against UMH race...

Hi,

the full fix would be to implement reset_resume() for btusb.
It seems to me that setup() should be split in two methods,
one to request the firmware from user space and the second
to transfer it to the device. reset_resume() would just need
to repeat the second operation.

	Regards
		Oliver



