Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaIAHQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 03:16:29 -0400
Received: from mga01.intel.com ([192.55.52.88]:61458 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbaIAHQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 03:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,440,1406617200"; 
   d="scan'208";a="584444447"
Message-ID: <1409555763.30155.39.camel@linux.intel.com>
Subject: Re: [PATCH v3 07/11] wireless: hostap: proc: print properly escaped
 SSID
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W . Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>
Date: Mon, 01 Sep 2014 10:16:03 +0300
In-Reply-To: <1408527772-27224-8-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1408527772-27224-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1408527772-27224-8-git-send-email-andriy.shevchenko@linux.intel.com>
Organization: Intel Finland Oy
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.5-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-20 at 12:42 +0300, Andy Shevchenko wrote:
> Instead of substituting non-printable characters by '_' let's print SSID
> properly escaped by using recently added %*pE specifier.

Here is kbuild robot fixup.

>From f88ff364a1b117d3c86186206eeaa54ff906147a Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Mon, 1 Sep 2014 10:13:28 +0300
Subject: [PATCH] wireless: hostap: kbuild robot fixup

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/net/wireless/hostap/hostap_proc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/hostap/hostap_proc.c
b/drivers/net/wireless/hostap/hostap_proc.c
index 16a06b6..5b1a510 100644
--- a/drivers/net/wireless/hostap/hostap_proc.c
+++ b/drivers/net/wireless/hostap/hostap_proc.c
@@ -181,7 +181,7 @@ static int prism2_bss_list_proc_show(struct seq_file
*m, void *v)
 		   bss->bssid, bss->last_update,
 		   bss->count, bss->capab_info);
 
-	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
+	seq_printf(m, "%*pE", (int)bss->ssid_len, bss->ssid);
 
 	seq_putc(m, '\t');
 	for (i = 0; i < bss->ssid_len; i++)
-- 
2.1.0


> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wireless/hostap/hostap_proc.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
> index 4e5c0f8..16a06b6 100644
> --- a/drivers/net/wireless/hostap/hostap_proc.c
> +++ b/drivers/net/wireless/hostap/hostap_proc.c
> @@ -181,9 +181,7 @@ static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
>  		   bss->bssid, bss->last_update,
>  		   bss->count, bss->capab_info);
>  
> -	for (i = 0; i < bss->ssid_len; i++)
> -		seq_putc(m,bss->ssid[i] >= 32 && bss->ssid[i] < 127 ?
> -			   bss->ssid[i] : '_');
> +	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
>  
>  	seq_putc(m, '\t');
>  	for (i = 0; i < bss->ssid_len; i++)


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

