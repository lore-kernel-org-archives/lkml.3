Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbaKXJNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 04:13:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36031 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751196AbaKXJNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 04:13:18 -0500
Message-ID: <1416820395.19925.4.camel@linux-0dmf.site>
Subject: Re: [PATCH] HID: usbhid: get/put around clearing needs_remote_wakeup
From: Oliver Neukum <oneukum@suse.de>
To: Benson Leung <bleung@chromium.org>
Cc: johan@kernel.org, Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sameer Nanda <snanda@chromium.org>
Date: Mon, 24 Nov 2014 10:13:15 +0100
In-Reply-To: <CANLzEkvcm5g_T+FsEQF2UFzS5A2u7CWgdTiEJAxidfxgAE5bHw@mail.gmail.com>
References: <1415909806-23848-1-git-send-email-bleung@chromium.org>
	 <1415956110.2640.5.camel@linux-0dmf.site>
	 <CANLzEkvcm5g_T+FsEQF2UFzS5A2u7CWgdTiEJAxidfxgAE5bHw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-21 at 17:00 -0800, Benson Leung wrote:

> If devices are already asleep with this flag enabled, that means that
> they are presently configured for remote wake.

Yes, but that doesn't matter. The drivers must be ready for a device
being resumed at any time. Remote wakeup just adds one more reason.

> Waking the device in the case of a close() is appropriate because it
> also has the effect of re-suspending the device with the capability
> disabled, as it is no longer necessary.

But there is very little to be gained by switching off remote wakeup.
The additional energy consumption devices with remote wakeup enabled
will be dwarfed by the energy needed for an additional wakeup.

	Regards
		Oliver


