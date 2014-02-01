Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474AbaBABtj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 20:49:39 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:21064 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754300AbaBABti convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 20:49:38 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdchz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h906i1155h)
Date: Fri, 31 Jan 2014 17:49:25 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] clk: Fix notifier documentation
References: <1390420117-25930-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1390420117-25930-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <57c43634-23a6-4dcf-8aff-f49961d7f4d6@TX2EHSMHS005.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On Wed, Jan 22, 2014 at 11:48:37AM -0800, Soren Brinkmann wrote:
> Contradicting to documenation, the notifier callbacks do receive
> the original clock rate in struct clk_notifier_data.old_rate and the new
> frequency struct clk_notifier_data.new_rate, independent of the
> notification reason.
> 
> This behavior also seems to make more sense, since callbacks can use the
> same code to deterimine whether clocks are scaled up or down. Something
> which would not even possible in the post-rate-change case if the
> behavior was as documented.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi Mike,
> 
> I am working with some clock notifiers and if my results are correct the
> notifiers behave differently from how they are documented.
> I think the actual behavior makes more sense than the documented and my original
> plan was to change the behavior, but it seems I might get away with a
> doc-update.
> 
> 	Thanks,
> 	Sören
> 
>  drivers/clk/clk.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index 2cf2ea6b77a1..26825db03e64 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1983,20 +1983,11 @@ EXPORT_SYMBOL_GPL(devm_clk_unregister);
>   * re-enter into the clk framework by calling any top-level clk APIs;
>   * this will cause a nested prepare_lock mutex.
>   *
> - * Pre-change notifier callbacks will be passed the current, pre-change
> - * rate of the clk via struct clk_notifier_data.old_rate.  The new,
> - * post-change rate of the clk is passed via struct
> + * In all notification cases cases (pre, post and abort rate change) the
> + * original clock rate is passed to the callback via struct
> + * clk_notifier_data.old_rate and the new frequency is passed via struct
>   * clk_notifier_data.new_rate.
>   *
> - * Post-change notifiers will pass the now-current, post-change rate of
> - * the clk in both struct clk_notifier_data.old_rate and struct
> - * clk_notifier_data.new_rate.
> - *
> - * Abort-change notifiers are effectively the opposite of pre-change
> - * notifiers: the original pre-change clk rate is passed in via struct
> - * clk_notifier_data.new_rate and the failed post-change rate is passed
> - * in via struct clk_notifier_data.old_rate.
> - *
>   * clk_notifier_register() must be called from non-atomic context.
>   * Returns -EINVAL if called with null arguments, -ENOMEM upon
>   * allocation failure; otherwise, passes along the return value of
> -- 
> 1.8.5.3
> 
> 

