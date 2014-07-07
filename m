Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaGGMha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 08:37:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51684 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752724AbaGGMh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 08:37:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Martin Kepplinger <martink@posteo.de>, rui.zhang@intel.com,
        lenb@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix backlight control for Acer TravelMate B113
Date: Mon, 07 Jul 2014 14:55:31 +0200
Message-ID: <1459819.oe49iEh54h@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53B0BD92.8090209@intel.com>
References: <1403555446-16863-1-git-send-email-martink@posteo.de> <53AFD16D.10209@posteo.de> <53B0BD92.8090209@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 30, 2014 09:29:54 AM Aaron Lu wrote:
> On 06/29/2014 04:42 PM, Martin Kepplinger wrote:
> > Am 2014-06-23 22:30, schrieb Martin Kepplinger:
> >> Fix backlight control for Acer TravelMate B113 Laptop by adding
> >> it to the video_dmi_table.
> >>
> >> A workaround before that was to use acpi_osi=Linux or
> >> acpi_backlight=vendor on boot but even then, only the function-
> >> keys worked.
> >>
> >> With this change there is no need for boot parameters and DE's
> >> controls work as well.
> >>
> >> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> >> Tested-by: Martin Kepplinger <martink@posteo.de>
> >> ---
> >>  drivers/acpi/video.c |    8 ++++++++
> >>  1 file changed, 8 insertions(+)
> >>
> >> diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
> >> index f8bc5a7..acb0670 100644
> >> --- a/drivers/acpi/video.c
> >> +++ b/drivers/acpi/video.c
> >> @@ -528,6 +528,14 @@ static struct dmi_system_id video_dmi_table[] __initdata = {
> >>  		},
> >>  	},
> >>  	{
> >> +	 .callback = video_set_use_native_backlight,
> >> +	 .ident = "Acer TravelMate B113",
> >> +	 .matches = {
> >> +		DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> >> +		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate B113"),
> >> +		},
> >> +	},
> >> +	{
> >>  	.callback = video_set_use_native_backlight,
> >>  	.ident = "HP ProBook 4340s",
> >>  	.matches = {
> >>
> > 
> > are there objections or advice on this? this would be really good to
> > have, even if for 3.17.
> 
> For v3.16, we already have this commit to make use_native_backlight
> equal to 1 by default:
> 
> commit 751109aad5834375ca9ed0dcfcd85a00cbf872b5
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Jun 5 22:47:35 2014 +0200
> 
>     ACPI / video: Change the default for video.use_native_backlight to 1

Nevertheless, we may need the blacklist entries in case we need to revert the
above commit and also in case we want them to be backported to -stable (or LTSI
etc.).

Rafael

