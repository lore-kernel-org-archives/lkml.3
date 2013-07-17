Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3GQMDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 08:03:10 -0400
Received: from mail-lb0-f169.google.com ([209.85.217.169]:47505 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754531Ab3GQMDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 08:03:08 -0400
Message-ID: <1374062583.1836.1.camel@ThinkPad-X230.localdomain>
Subject: Re: [Update][PATCH] ACPI / video / i915: Remove ACPI backlight if
 firmware expects Windows 8
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        Aaron Lu <aaron.lwe@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "daniel.vetter@ffwll.ch" <daniel.vetter@ffwll.ch>,
        "seth.forshee@canonical.com" <seth.forshee@canonical.com>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>
Date: Wed, 17 Jul 2013 16:03:03 +0400
In-Reply-To: <1953381.pqik7pbieu@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <2132122.eIEvjmIrrj@vostro.rjw.lan>
	 <1374038198.1884.1.camel@ThinkPad-X230.localdomain>
	 <1953381.pqik7pbieu@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 13:38 +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 17, 2013 09:16:38 AM Igor Gnatenko wrote:
> > On Wed, 2013-07-17 at 00:01 +0200, Rafael J. Wysocki wrote:
> > > On Tuesday, July 16, 2013 05:08:16 PM Matthew Garrett wrote:
> > > > On Tue, 2013-07-16 at 17:32 +0400, Igor Gnatenko wrote:
> > > > > Hmm. I found regression in user-space. In GNOME (maybe and other DEs) we no longer see switch status of backlight.
> > > > 
> > > > Yeah, I can duplicate that. Rafael, we have to call
> > > > acpi_video_init_brightness() even if we're not going to initialise the
> > > > backlight - Thinkpads seem to use this as the trigger for enabling ACPI
> > > > notifications rather than handling it in firmware. This seems to do the
> > > > job:
> > > 
> > > Igor, does this additional patch from Matthew help?
> > Yes. With this patch I have backlight switch indicator on my ThinkPad X230.
> 
> OK, thanks for the confirmation.
> 
> Can you please also check if applying the appended patch on top of the Matthew's
> one changes anything (ie. things still work)?
Yes. I've tested and not found regressions in indicator or in switcher. Good work.
> 
> Rafael
> 
> 
> ---
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
>  drivers/acpi/video.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> Index: linux-pm/drivers/acpi/video.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/video.c
> +++ linux-pm/drivers/acpi/video.c
> @@ -957,6 +957,11 @@ static void acpi_video_device_find_cap(s
>  		if (result)
>  			printk(KERN_ERR PREFIX "Create sysfs link\n");
>  
> +	} else {
> +		/* Remove the brightness object. */
> +		kfree(device->brightness->levels);
> +		kfree(device->brightness);
> +		device->brightness = NULL;
>  	}
>  }
>  
> 
> 
-- 
Igor Gnatenko
Fedora release 19 (Schrödinger’s Cat)
Linux 3.11.0-0.rc0.git7.1.fc20.x86_64

