Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBMR6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 12:58:36 -0500
Received: from static-209-166-131-148.expedient.com ([209.166.131.148]:34459
	"EHLO natasha.panasas.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751397AbaBMR6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 12:58:35 -0500
Message-ID: <52FD07AF.1030604@panasas.com>
Date: Thu, 13 Feb 2014 19:58:07 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Rashika Kheria <rashika.kheria@gmail.com>
CC: <linux-kernel@vger.kernel.org>, Benny Halevy <bhalevy@tonian.com>,
        <osd-dev@open-osd.org>, <josh@joshtriplett.org>
Subject: Re: [PATCH 05/21] fs: Mark function as static in exofs/super.c
References: <b572932c3e016c55e596686283036316a1aacd2f.1391949868.git.rashika.kheria@gmail.com> <008a7e048e6eee2d773e092660183f21d52e4874.1391949868.git.rashika.kheria@gmail.com>
In-Reply-To: <008a7e048e6eee2d773e092660183f21d52e4874.1391949868.git.rashika.kheria@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 03:01 PM, Rashika Kheria wrote:
> Mark function as static in exofs/super.c because it is not used outside
> this file.
> 
> This also eliminates the following warning in exofs/super.c:
> fs/exofs/super.c:546:5: warning: no previous prototype for ‘__alloc_dev_table’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Hi Rashika

Thanks for the fixes.

Do you need me to push it to Linus through my tree or do you need an:
ACK-by: Boaz Harrosh <bharrosh@panasas.com>

[Same for [PATCH 06/21] fs: Mark functions as static in exofs/ore_raid.c ]

Thanks again
Boaz

> ---
>  fs/exofs/super.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/exofs/super.c b/fs/exofs/super.c
> index 9d97633..57f59a2 100644
> --- a/fs/exofs/super.c
> +++ b/fs/exofs/super.c
> @@ -543,8 +543,8 @@ static int exofs_devs_2_odi(struct exofs_dt_device_info *dt_dev,
>  	return !(odi->systemid_len || odi->osdname_len);
>  }
>  
> -int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
> -		      struct exofs_dev **peds)
> +static int __alloc_dev_table(struct exofs_sb_info *sbi, unsigned numdevs,
> +			     struct exofs_dev **peds)
>  {
>  	struct __alloc_ore_devs_and_exofs_devs {
>  		/* Twice bigger table: See exofs_init_comps() and comment at
> 

