Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3GQFQq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:16:46 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:48186 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab3GQFQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:16:44 -0400
Message-ID: <1374038198.1884.1.camel@ThinkPad-X230.localdomain>
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
Date: Wed, 17 Jul 2013 09:16:38 +0400
In-Reply-To: <2132122.eIEvjmIrrj@vostro.rjw.lan>
References: <1370818899-8595-1-git-send-email-matthew.garrett@nebula.com>
	 <1373981554.1956.5.camel@ThinkPad-X230.localdomain>
	 <1373994495.9314.1.camel@x230> <2132122.eIEvjmIrrj@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.3 (3.8.3-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 00:01 +0200, Rafael J. Wysocki wrote:
> On Tuesday, July 16, 2013 05:08:16 PM Matthew Garrett wrote:
> > On Tue, 2013-07-16 at 17:32 +0400, Igor Gnatenko wrote:
> > > Hmm. I found regression in user-space. In GNOME (maybe and other DEs) we no longer see switch status of backlight.
> > 
> > Yeah, I can duplicate that. Rafael, we have to call
> > acpi_video_init_brightness() even if we're not going to initialise the
> > backlight - Thinkpads seem to use this as the trigger for enabling ACPI
> > notifications rather than handling it in firmware. This seems to do the
> > job:
> 
> Igor, does this additional patch from Matthew help?
Yes. With this patch I have backlight switch indicator on my ThinkPad X230.
> 
> Rafael
> 
> 
Tested-by: Igor Gnatenko <i.gnatenko.brain@gmail.com>
> > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > index 01b1a25..71865f7 100644
> > --- a/drivers/acpi/video.c
> > +++ b/drivers/acpi/video.c
> > @@ -900,6 +900,9 @@ static void acpi_video_device_find_cap(struct
> > acpi_video_device *device)
> >  		device->cap._DDC = 1;
> >  	}
> >  
> > +	if (acpi_video_init_brightness(device))
> > +		return;
> > +
> >  	if (acpi_video_verify_backlight_support()) {
> >  		struct backlight_properties props;
> >  		struct pci_dev *pdev;
> > @@ -909,9 +912,6 @@ static void acpi_video_device_find_cap(struct
> > acpi_video_device *device)
> >  		static int count = 0;
> >  		char *name;
> >  
> > -		result = acpi_video_init_brightness(device);
> > -		if (result)
> > -			return;
> >  		name = kasprintf(GFP_KERNEL, "acpi_video%d", count);
> >  		if (!name)
> >  			return;
> > 
> > 
> > -- 
> > Matthew Garrett | mjg59@srcf.ucam.org
> > 
-- 
Igor Gnatenko
Fedora release 19 (Schrödinger’s Cat)
Linux 3.11.0-0.rc0.git7.1.fc20.x86_64

