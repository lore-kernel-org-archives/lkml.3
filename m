Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3CRRwj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:52:39 -0400
Received: from mail-ia0-f175.google.com ([209.85.210.175]:42960 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3CRRwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:52:38 -0400
MIME-Version: 1.0
In-Reply-To: <1363602109-12001-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1363602109-12001-1-git-send-email-linfeng@cn.fujitsu.com>
Date: Mon, 18 Mar 2013 10:52:37 -0700
X-Google-Sender-Auth: AnEXWJwzSd3eR_FSppJfaGGATnY
Message-ID: <CAE9FiQUrt11A0YAOLgvv3uTAWtTvVg3Mho9eD53orbxW6Jd8Vg@mail.gmail.com>
Subject: Re: [PATCH] kernel/range.c: subtract_range: return instead of
 continue to save some loops
From: Yinghai Lu <yinghai@kernel.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: akpm@linux-foundation.org, bhelgaas@google.com, linux-mm@kvack.org,
        x86@kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 3:21 AM, Lin Feng <linfeng@cn.fujitsu.com> wrote:
> If we fall into that branch it means that there is a range fully covering the
> subtract range, so it's suffice to return there if there isn't any other
> overlapping ranges.
>
> Also fix the broken phrase issued by printk.
>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Lin Feng <linfeng@cn.fujitsu.com>
> ---
>  kernel/range.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/range.c b/kernel/range.c
> index 9b8ae2d..223c6fe 100644
> --- a/kernel/range.c
> +++ b/kernel/range.c
> @@ -97,10 +97,10 @@ void subtract_range(struct range *range, int az, u64 start, u64 end)
>                                 range[i].end = range[j].end;
>                                 range[i].start = end;
>                         } else {
> -                               printk(KERN_ERR "run of slot in ranges\n");
> +                               printk(KERN_ERR "run out of slot in ranges\n");

maybe could change to pr_err at the same time.

>                         }
>                         range[j].end = start;
> -                       continue;
> +                       return;

We don't say that ranges can not be overlapped in the array.

Thanks

Yinghai
