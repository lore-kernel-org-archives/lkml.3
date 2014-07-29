Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210AbaG2JMC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 05:12:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39782 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752780AbaG2JL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 05:11:59 -0400
Date: Tue, 29 Jul 2014 11:11:53 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Benjamin Tissoires <benjamin.tissoires@redhat.com>
cc: Andrew Duggan <aduggan@synaptics.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vincent Huang <vincent.huang@tw.synaptics.com>,
        Mika Westerberg <mika.westerberg@intel.com>
Subject: Re: [PATCH] HID: i2c-hid: call the hid driver's suspend and resume
 callbacks
In-Reply-To: <20140717170031.GC27586@mail.corp.redhat.com>
Message-ID: <alpine.LNX.2.00.1407291111320.16390@pobox.suse.cz>
References: <1405121658-3853-1-git-send-email-aduggan@synaptics.com> <20140717170031.GC27586@mail.corp.redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2014, Benjamin Tissoires wrote:

> > Currently, the i2c-hid driver does not call the suspend, resume, and
> > reset_resume callbacks in the hid_driver struct when those events occur.
> > This means that HID drivers for i2c-hid devices will not be able to execute
> > commands which may be needed during suspend or resume. One example is when a
> > touchpad using the hid-multitouch driver gets reset by i2c-hid coming out of
> > resume. Since the reset_resume callback never gets called the device is never
> > put back into the correct input mode. This patch calls the suspend and resume
> > callbacks and tries to duplicate the functionality of the usb-hid driver.
> > 
> > Signed-off-by: Andrew Duggan <aduggan@synaptics.com>
> > Signed-off-by: Vincent Huang <vincent.huang@tw.synaptics.com>
> > ---
> > Hi Benjamin,
> > 
> > This is the patch which Vincent and I came up with to fix the behavior which we were seeing with touchpads not being operational after resuming. We only use the reset_resume callback since i2c_hid_resume is always doing a hardware reset and it doesn't seem like there is a condition in which the standard resume callback would be appropriate. Also, is a full hardware reset always needed when resuming?
> 
> Hi Andrew,
> 
> well, the PM management of i2c_hid has been handled by Mika (in CC) and
> I am unfortunately not able to have a strong opinion on this. I still
> lack of hardware properly supporting the suspend/resume mechanism.
> 
> So, you are in charge of that. IIRC, nothing prevents from not calling
> hw_reset, but I guess this was the safer implementation we could have.
> 
> Anyway, the patch looks good:
> Reviewed-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

I am queuing this for 3.17. Mika, if you have any objections, please speak 
up.

Thanks,

-- 
Jiri Kosina
SUSE Labs
