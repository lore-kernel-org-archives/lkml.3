Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbaIYX0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 19:26:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:60711 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751981AbaIYX0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 19:26:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 10/22] ACPI / battery: Replace strnicmp with strncasecmp
Date: Fri, 26 Sep 2014 01:46:08 +0200
Message-ID: <1916199.r47gMNIv64@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410900696-6481-11-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk> <1410900696-6481-11-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 16, 2014 10:51:24 PM Rasmus Villemoes wrote:
> The kernel used to contain two functions for length-delimited,
> case-insensitive string comparison, strnicmp with correct semantics
> and a slightly buggy strncasecmp. The latter is the POSIX name, so
> strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
> for the new strncasecmp to avoid breaking existing users.
> 
> To allow the compat wrapper strnicmp to be removed at some point in
> the future, and to avoid the extra indirection cost, do
> s/strnicmp/strncasecmp/g.
> 
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Len Brown <lenb@kernel.org>
> Cc: linux-acpi@vger.kernel.org
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Queued up for 3.18, thanks!

> ---
>  drivers/acpi/battery.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index 5fdfe65..8ec8a89 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -695,7 +695,7 @@ static void acpi_battery_quirks(struct acpi_battery *battery)
>  	if (battery->power_unit && dmi_name_in_vendors("LENOVO")) {
>  		const char *s;
>  		s = dmi_get_system_info(DMI_PRODUCT_VERSION);
> -		if (s && !strnicmp(s, "ThinkPad", 8)) {
> +		if (s && !strncasecmp(s, "ThinkPad", 8)) {
>  			dmi_walk(find_battery, battery);
>  			if (test_bit(ACPI_BATTERY_QUIRK_THINKPAD_MAH,
>  				     &battery->flags) &&
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
