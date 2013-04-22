Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3DVGSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 02:18:42 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:54247 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab3DVGSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 02:18:41 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
References: <1366609643-17628-1-git-send-email-lig.fnst@cn.fujitsu.com>
Date: Mon, 22 Apr 2013 08:18:39 +0200
Message-ID: <CA+icZUVd3zp-pJDspBUsipH4725uUvaufXrK0QBzcrozF2m+aA@mail.gmail.com>
Subject: Re: [PATCH 1/2] smp: use '|=' for csd_lock
From: Sedat Dilek <sedat.dilek@gmail.com>
To: liguang <lig.fnst@cn.fujitsu.com>
Cc: tglx@linutronix.de, peterz@infradead.org, akpm@linux-foundation.org,
        shli@fusionio.com, srivatsa.bhat@linux.vnet.ibm.com,
        suresh.b.siddha@intel.com, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 7:47 AM, liguang <lig.fnst@cn.fujitsu.com> wrote:
> originally, 'data->flags = CSD_FLAG_LOCK',
> and we use 'data->flags &= ~CSD_FLAG_LOCK'
> for csd_unlock, they are not symmetrix operations
> so use '|=' instead of '='.
> though, now data->flags only hold CSD_FLAG_LOCK,
> it's not so meaningful to use '|=' to set 1 bit,
> and '&= ~' to clear 1 bit.
>

Hi,

what's the reason I got CCed on this two patches? The ipc-sem-next
issue I reported?

Against what tree are those patches?
They are not compatible with Linux-Next (next-20130419).

Thanks.

Regards,
- Sedat -

[1] http://marc.info/?t=136631457900005&r=1&w=2

> Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
> ---
>  kernel/smp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/smp.c b/kernel/smp.c
> index 1818dc0..2d5deb4 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -109,7 +109,7 @@ static void csd_lock_wait(struct call_single_data *data)
>  static void csd_lock(struct call_single_data *data)
>  {
>         csd_lock_wait(data);
> -       data->flags = CSD_FLAG_LOCK;
> +       data->flags |= CSD_FLAG_LOCK;
>
>         /*
>          * prevent CPU from reordering the above assignment
> --
> 1.7.2.5
>
