Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaHKWBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 18:01:08 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:49516 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438AbaHKWBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 18:01:05 -0400
Subject: Re: [PATCH] Made bpf_internal_load_pointer_neg_helper static:
 fixes Sparse warning
From: Benjamin Lee <leeben@linux.vnet.ibm.com>
To: davem@davemloft.net, linux-kernel@vger.kernel.org
Cc: dany@us.ibm.com, dany4madden@gmail.com, benjamin.fik.lee@gmail.com
In-Reply-To: <1405708449.11800.2.camel@oc1318858833.ibm.com>
References: <1405708449.11800.2.camel@oc1318858833.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Aug 2014 15:00:56 -0700
Message-ID: <1407794456.12335.3.camel@oc1318858833.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081122-0320-0000-0000-00000033B854
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wanted to know what the current status of my patch is since my
internship will be ending this Friday and I want to know before then. if
there are any problems with it I can fix them before Thursday. Thank you
in advance.

On Fri, 2014-07-18 at 11:34 -0700, Benjamin Lee wrote:
> This patch fixes the following Sparse warning:
> 
> net/core/filter.c:52:6: warning: symbol
> 'bpf_internal_load_pointer_neg_helper' was not declared. Should it be
> static?
> 
> I declared bpf_internal_load_pointer_neg_helper as static because it  
> is not referenced elsewhere in the kernel. The patched kernel boots  
> and runs OK. I verified that the section of code is actually being  
> compiled by temporarily placing a #pragma message inside the function.  
> I also verified that the function is being called by temporarily  
> inserting a call to panic.
> 
> I am a high school student trying to become familiar with the open  
> source process and the Linux kernel, so your guidance is appreciated.
> 
> Signed-off-by Benjamin Lee <leeben@linux.vnet.ibm.com>
> Reviewed-by: Dany Madden <danymadden@us.ibm.com>
> Reviewed-by: Jim Keniston <jkenisto@us.ibm.com>
> 
> ---
>   net/core/filter.c |    3 ++-
>   1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 735fad8..068442a 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -70,7 +70,8 @@
>    *
>    * Exported for the bpf jit load helper.
>    */
> -void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb, int k, unsigned int size)
> +static void *bpf_internal_load_pointer_neg_helper(const struct sk_buff *skb,
> +                                                 int k, unsigned int
> size)
>   {
>         u8 *ptr = NULL;
> 


