Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbaGYHWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 03:22:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:46257 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbaGYHW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 03:22:29 -0400
Date: Fri, 25 Jul 2014 09:22:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/7] crypto: SHA1 multibuffer crypto opportunistic
 flush
Message-ID: <20140725072225.GT3935@laptop>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
 <1406066975.2970.805.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406066975.2970.805.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:09:35PM -0700, Tim Chen wrote:
> The crypto daemon can take advantage of available cpu
> cycles to flush any unfinished jobs if it is the
> only task running on the cpu, and there are no more crypto
> jobs to process.

You conveniently forgot to mention energy efficiency, and the problem
with short idle durations. Although the latter issue seems overshadowed
by the not so very robust idle detection.

In any case, same as the other patch, you can get similarly inconclusive
semantics without single_task_running().

> Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
> ---
>  crypto/mcryptd.c | 39 ++++++++++++++++++++++++++++++++++++---
>  1 file changed, 36 insertions(+), 3 deletions(-)

> +/*
> + * Called in workqueue context, do one real cryption work (via
>   * req->complete) and reschedule itself if there are more work to
> - * do. */
> + * do.
> + */

See, this should've been in the previous patch :-)
