Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbaFFENA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:13:00 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:48499 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730AbaFFEM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:12:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140606140651.1c393d7a@canb.auug.org.au>
References: <20140606140651.1c393d7a@canb.auug.org.au>
Date: Thu, 5 Jun 2014 21:12:56 -0700
Message-ID: <CAADnVQL0Lc5a9MLUc3JUjrJsNZe3H16=7+FomdXDspO0cOoFHQ@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 9:06 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> After merging the net-next tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> net/core/filter.c: In function 'convert_bpf_extensions':
> net/core/filter.c:696:17: error: 'A_REG' undeclared (first use in this function)
>    insn->a_reg = A_REG;
>                  ^
>
> Caused by my bad merge resolution :-(
>
> I applied this in the hope that it is correct (at least it builds):

Thank you.
It is correct.
I think Dave was about to push the same fix to net-next.
You're too fast :)

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 6 Jun 2014 14:00:07 +1000
> Subject: [PATCH] net: filter: merge fix up
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  net/core/filter.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/net/core/filter.c b/net/core/filter.c
> index 7b46e4553c17..74dd87596257 100644
> --- a/net/core/filter.c
> +++ b/net/core/filter.c
> @@ -691,10 +691,7 @@ static bool convert_bpf_extensions(struct sock_filter *fp,
>                 *insn = BPF_ALU32_IMM(BPF_AND, BPF_REG_A, PKT_TYPE_MAX);
>  #ifdef __BIG_ENDIAN_BITFIELD
>                 insn++;
> -
> -               insn->code = BPF_ALU | BPF_RSH | BPF_K;
> -               insn->a_reg = A_REG;
> -               insn->imm = 5;
> +               *insn = BPF_ALU32_IMM(BPF_RSH, BPF_REG_A, 5);
>  #endif
>                 break;
>
> --
> 2.0.0
>
> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
