Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934084Ab3HHIvu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 04:51:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49982 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934009Ab3HHIvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 04:51:48 -0400
Date: Thu, 8 Aug 2013 10:51:33 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Ingo Molnar <mingo@kernel.org>, David Daney <david.daney@cavium.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] extable: Skip sorting if the table is empty
Message-ID: <20130808085133.GP6104@pengutronix.de>
References: <1374047711-21518-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1374047711-21518-1-git-send-email-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

[adding akpm to Cc:]

On Wed, Jul 17, 2013 at 09:55:11AM +0200, Uwe Kleine-König wrote:
> At least on ARM no-MMU the extable is empty and so there is nothing to
> sort. So add a check for the table to be empty which effectively only
> changes that the misleading pr_notice is suppressed.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I first tried to select BUILDTIME_EXTABLE_SORT for ARM no-MMU, too, but that
> failed to build with
> 
> 	no __ex_table in  file: vmlinux
> 
> . I didn't dig deeper for the reasons, but maybe this is worth fixing, too?
this doesn't appear in current next and I didn't get any feed back yet.

What do you think?

Thanks
Uwe

>  kernel/extable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/extable.c b/kernel/extable.c
> index 67460b9..832cb28 100644
> --- a/kernel/extable.c
> +++ b/kernel/extable.c
> @@ -41,7 +41,7 @@ u32 __initdata main_extable_sort_needed = 1;
>  /* Sort the kernel's built-in exception table */
>  void __init sort_main_extable(void)
>  {
> -	if (main_extable_sort_needed) {
> +	if (main_extable_sort_needed && __stop___ex_table > __start___ex_table) {
>  		pr_notice("Sorting __ex_table...\n");
>  		sort_extable(__start___ex_table, __stop___ex_table);
>  	}

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
