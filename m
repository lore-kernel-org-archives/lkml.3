Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3GVQNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42436 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933052Ab3GVQNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [ 10/18] ACPI / EC: Add HP Folio 13 to ec_dmi_table in order to skip DSDT scan
References: <20130719021048.965829361@linuxfoundation.org>
	<20130719021049.669930750@linuxfoundation.org>
Date: Mon, 22 Jul 2013 17:13:29 +0100
In-Reply-To: <20130719021049.669930750@linuxfoundation.org> (Greg
	Kroah-Hartman's message of "Thu, 18 Jul 2013 19:23:25 -0700")
Message-ID: <87txjm609i.fsf@canonical.com>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> 3.0-stable review patch.  If anyone has any objections, please let me know.

Sorry for the late review, but this patch is actually tagged for
stable kernels >= 3.9 ("Cc: 3.9+ <stable@vger.kernel.org>").  But it
is probably harmless and not worth the trouble of reverting them from
3.0 and 3.4.

Cheers,
-- 
Luis


>
> ------------------
>
> From: Lan Tianyu <tianyu.lan@intel.com>
>
> commit eff9a4b62b14cf0d9913e3caf1f26f8b7a6105c9 upstream.
>
> HP Folio 13's BIOS defines CMOS RTC Operation Region and the EC's
> _REG method will access that region.  To allow the CMOS RTC region
> handler to be installed before the EC _REG method is first invoked,
> add ec_skip_dsdt_scan() as HP Folio 13's callback to ec_dmi_table.
>
> References: https://bugzilla.kernel.org/show_bug.cgi?id=54621
> Reported-and-tested-by: Stefan Nagy <public@stefan-nagy.at>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>
> ---
>  drivers/acpi/ec.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- a/drivers/acpi/ec.c
> +++ b/drivers/acpi/ec.c
> @@ -964,6 +964,10 @@ static struct dmi_system_id __initdata e
>  	ec_enlarge_storm_threshold, "CLEVO hardware", {
>  	DMI_MATCH(DMI_SYS_VENDOR, "CLEVO Co."),
>  	DMI_MATCH(DMI_PRODUCT_NAME, "M720T/M730T"),}, NULL},
> +	{
> +	ec_skip_dsdt_scan, "HP Folio 13", {
> +	DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
> +	DMI_MATCH(DMI_PRODUCT_NAME, "HP Folio 13"),}, NULL},
>  	{},
>  };
>  
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
