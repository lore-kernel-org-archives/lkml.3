Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186Ab3CEJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 04:12:29 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:34007 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903Ab3CEJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 04:12:27 -0500
MIME-Version: 1.0
In-Reply-To: <1362388174-3435-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1362388174-3435-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1362388174-3435-5-git-send-email-andriy.shevchenko@linux.intel.com>
Date: Tue, 5 Mar 2013 17:12:26 +0800
Message-ID: <CAKohpomECZjXcaM-n64vfq+DMc9_G2aqa5ShfJ4j+_wVaeBrRQ@mail.gmail.com>
Subject: Re: [PATCH 04/10] dmatest: move dmatest_channels and nr_channels to dmatest_info
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 March 2013 17:09, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> We don't need to have them global and later we would like to protect access to
> them as well.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/dma/dmatest.c | 29 ++++++++++++++++-------------
>  1 file changed, 16 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
> index 7f9e3cc..475a21a 100644
> --- a/drivers/dma/dmatest.c
> +++ b/drivers/dma/dmatest.c
> @@ -109,6 +109,7 @@ struct dmatest_chan {
>   * @timeout:           transfer timeout in msec, -1 for infinite timeout
>   */
>  struct dmatest_info {
> +       /* Test parameters */
>         unsigned int    buf_size;
>         char            channel[20];
>         char            device[20];
> @@ -118,17 +119,14 @@ struct dmatest_info {
>         unsigned int    xor_sources;
>         unsigned int    pq_sources;
>         int             timeout;
> +
> +       /* Internal state */
> +       struct list_head        channels;
> +       unsigned int            nr_channels;
>  };

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

What about merging this patch with the patch which added this structure.
