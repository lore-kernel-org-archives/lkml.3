Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035Ab3GJQX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 12:23:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712Ab3GJQXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 12:23:54 -0400
Subject: Re: [PATCH] dmi_scan: Add comments on dmi_present() and the loop
 in dmi_scan_machine()
From: Jean Delvare <jdelvare@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1373466723.24446.10.camel@deadeye.wl.decadent.org.uk>
References: <1373466723.24446.10.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Suse Linux
Date: Wed, 10 Jul 2013 18:23:35 +0200
Message-ID: <1373473415.4399.53.camel@chaos.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

Le Wednesday 10 July 2013 à 15:32 +0100, Ben Hutchings a écrit :
> My previous refactoring in commit 79bae42d51a5 resulted in slightly
> tricky code (though I think it's more elegant).  Explain what it's
> doing.

You are being very nice to me, not sure I deserve it ;-)

> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/firmware/dmi_scan.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
> index b95159b..4fdb377 100644
> --- a/drivers/firmware/dmi_scan.c
> +++ b/drivers/firmware/dmi_scan.c
> @@ -419,6 +419,13 @@ static void __init dmi_format_ids(char *buf, size_t len)
>  			    dmi_get_system_info(DMI_BIOS_DATE));
>  }
>  
> +/*
> + * Check for DMI/SMBIOS headers in the system firmware image.  Any
> + * SMBIOS header must start 16 bytes before the DMI header, so take a
> + * 32 byte buffer and check for DMI at offset 16 and SMBIOS at offset
> + * 0.  If the DMI header is present, set dmi_ver accordingly (SMBIOS
> + * takes precedence) and return 0.  Otherwise return 1.
> + */
>  static int __init dmi_present(const u8 *buf)
>  {
>  	int smbios_ver;
> @@ -506,6 +513,13 @@ void __init dmi_scan_machine(void)
>  		if (p == NULL)
>  			goto error;
>  
> +		/*
> +		 * Iterate over all possible DMI header addresses q.
> +		 * Maintain the 32 bytes around q in buf.  On the
> +		 * first iteration, substitute zero for the
> +		 * out-of-range bytes so there is no chance of falsely
> +		 * detecting an SMBIOS header.
> +		 */
>  		memset(buf, 0, 16);
>  		for (q = p; q < p + 0x10000; q += 16) {
>  			memcpy_fromio(buf + 16, q, 16);
> 

Yes, I like it, good idea.

Reviewed-by: Jean Delvare <jdelvare@suse.de>

-- 
Jean Delvare
Suse L3

