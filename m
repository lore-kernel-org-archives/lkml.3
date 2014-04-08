Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaDHMOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 08:14:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62674 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756604AbaDHMN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 08:13:59 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Stephen Chandler Paul <thatslyude@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Rutledge <shawn.t.rutledge@gmail.com>
Subject: Re: [PATCH] Favor native backlight interface for ThinkPad Helix
Date: Tue, 08 Apr 2014 14:29:58 +0200
Message-ID: <1774484.W0F2y2oSm2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <534363AD.9070401@intel.com>
References: <1396622686-6373-1-git-send-email-thatslyude@gmail.com> <534363AD.9070401@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 10:49:17 AM Aaron Lu wrote:
> On 04/04/2014 10:44 PM, Stephen Chandler Paul wrote:
> > Like many other Windows 8 laptops the ThinkPad Helix's backlight has a
> > broken ACPI interface and can only be properly adjusted by using the
> > video card's native backlight control. This adds the ThinkPad Helix to
> > the list of laptops affected with this issue so that
> > video.use_native_backlight is enabled by default.
> 
> It would be good to attach your acpidump so that we know for sure and if
> one day we need to remove this entry, we can verify its table.
> 
> Bug 51231 is tracking this problem and mostly are thinkpad laptops, so
> please attach your acpidump and dmi there, thanks.
> https://bugzilla.kernel.org/show_bug.cgi?id=51231

I've queued this patch up for the next ACPI pull request.  We'll revert it
if it turns out to be incorrect.

> > Signed-off-by: Stephen Chandler Paul <thatslyude@gmail.com>
> > ---
> >  drivers/acpi/video.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> > index 48c7e8a..8b6990e 100644
> > --- a/drivers/acpi/video.c
> > +++ b/drivers/acpi/video.c
> > @@ -488,6 +488,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
> >  		},
> >  	},
> >  	{
> > +	.callback = video_set_use_native_backlight,
> > +	.ident = "Thinkpad Helix",
> > +	.matches = {
> > +		DMI_MATCH(DMI_SYS_Vhttps://bugzilla.kernel.org/show_bug.cgi?id=51231ENDOR, "LENOVO"),
> > +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad Helix"),
> > +		},
> > +	},
> > +	{
> >  	 .callback = video_set_use_native_backlight,
> >  	 .ident = "Dell Inspiron 7520",
> >  	 .matches = {
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
