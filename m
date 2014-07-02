Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaGBDgV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 23:36:21 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:52304 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaGBDgU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 23:36:20 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Sachin Kamat <sachin.kamat@samsung.com>, linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1404195994-32354-1-git-send-email-sachin.kamat@samsung.com>
Cc: spk.linux@gmail.com, "Peter De Schrijver" <pdeschrijver@nvidia.com>
References: <1404195994-32354-1-git-send-email-sachin.kamat@samsung.com>
Message-ID: <20140702033606.32686.67534@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH v2 1/1] clk: Fix build warnings
Date: Tue, 01 Jul 2014 20:36:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Sachin Kamat (2014-06-30 23:26:34)
> ‘all_lists’ and ‘orphan_list’ is accessed only when DEBUG_FS is defined.
> Thus, make their compilation conditional to fix the below warnings introduced
> by commit 27b8d5f723 ("clk: flatten clk tree in debugfs"):
> drivers/clk/clk.c:40:27: warning: ‘all_lists’ defined but not used [-Wunused-variable]
> drivers/clk/clk.c:46:27: warning: ‘orphan_list’ defined but not used [-Wunused-variable]
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@samsung.com>
> Cc: Peter De Schrijver <pdeschrijver@nvidia.com>

Applied.

Thanks,
Mike

> ---
> Changes since v1:
> Moved the definitions under already existing #ifdefs.
> ---
>  drivers/clk/clk.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 7dfb2f308b35..958967d141ee 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -36,17 +36,6 @@ static HLIST_HEAD(clk_root_list);
>  static HLIST_HEAD(clk_orphan_list);
>  static LIST_HEAD(clk_notifier_list);
>  
> -static struct hlist_head *all_lists[] = {
> -       &clk_root_list,
> -       &clk_orphan_list,
> -       NULL,
> -};
> -
> -static struct hlist_head *orphan_list[] = {
> -       &clk_orphan_list,
> -       NULL,
> -};
> -
>  /***           locking             ***/
>  static void clk_prepare_lock(void)
>  {
> @@ -111,6 +100,17 @@ static void clk_enable_unlock(unsigned long flags)
>  static struct dentry *rootdir;
>  static int inited = 0;
>  
> +static struct hlist_head *all_lists[] = {
> +       &clk_root_list,
> +       &clk_orphan_list,
> +       NULL,
> +};
> +
> +static struct hlist_head *orphan_list[] = {
> +       &clk_orphan_list,
> +       NULL,
> +};
> +
>  static void clk_summary_show_one(struct seq_file *s, struct clk *c, int level)
>  {
>         if (!c)
> -- 
> 1.7.9.5
> 
