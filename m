Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaFGPXx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 11:23:53 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:60521 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaFGPXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 11:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140607123518.88983301D2@webmail.sinamail.sina.com.cn>
References: <20140607123518.88983301D2@webmail.sinamail.sina.com.cn>
Date: Sat, 7 Jun 2014 10:23:50 -0500
Message-ID: <CAMP44s366jWnpyz1+th9+ndrD8XbPgEgOokQPYpBKS=suzeUdA@mail.gmail.com>
Subject: Re: Interactivity regression since v3.11 in mm/vmscan.c
From: Felipe Contreras <felipe.contreras@gmail.com>
To: zhdxzx@sina.com
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, dhillf <dhillf@gmail.com>,
        "hillf.zj" <hillf.zj@alibaba-inc.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 7, 2014 at 7:35 AM,  <zhdxzx@sina.com> wrote:

> Would you please try again based only on comment [1](based on v3.15-rc8)?
> thanks
> Hillf
>
> --- a/mm/vmscan.c       Sat Jun  7 18:38:08 2014
> +++ b/mm/vmscan.c       Sat Jun  7 20:08:36 2014
> @@ -1566,7 +1566,7 @@ shrink_inactive_list(unsigned long nr_to
>                  * implies that pages are cycling through the LRU faster than
>                  * they are written so also forcibly stall.
>                  */
> -               if (nr_unqueued_dirty == nr_taken || nr_immediate)
> +               if (nr_immediate)
>                         congestion_wait(BLK_RW_ASYNC, HZ/10);
>         }

That actually seems to work correctly on v3.15-rc8.

-- 
Felipe Contreras
