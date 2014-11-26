Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147AbaKZQmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 11:42:14 -0500
Received: from mail-qg0-f46.google.com ([209.85.192.46]:36481 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaKZQmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 11:42:10 -0500
MIME-Version: 1.0
Date: Wed, 26 Nov 2014 08:42:09 -0800
Message-ID: <CAADnVQK8mn4ZHwbhBArosEw3Bmsc5vJfOzAeRE3R_1S7dbNfkg@mail.gmail.com>
Subject: Re: [PATCH] x86: bpf_jit_comp: simplify trivial boolean return
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: Quentin Lambert <lambert.quentin@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 1:18 AM, Quentin Lambert
<lambert.quentin@gmail.com> wrote:
> Remove if then else statements preceding
> boolean return. Occurences were found using
> Coccinelle.
>
> The semantic patch used was:
>
> @@
> expression expr;
> @@
>
>
> - if ( expr )
> -       return true;
> - else
> -       return false;
> + return expr;
>
> Signed-off-by: Quentin Lambert <lambert.quentin@gmail.com>
>
> ---
>  arch/x86/net/bpf_jit_comp.c |    8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> index 3f62734..1542f39 100644
> --- a/arch/x86/net/bpf_jit_comp.c
> +++ b/arch/x86/net/bpf_jit_comp.c
> @@ -135,11 +135,9 @@ static const int reg2hex[] = {
>   */
>  static inline bool is_ereg(u32 reg)
>  {
> -       if (reg == BPF_REG_5 || reg == AUX_REG ||
> -           (reg >= BPF_REG_7 && reg <= BPF_REG_9))
> -               return true;
> -       else
> -               return false;
> +       return (reg == BPF_REG_5 ||
> +               reg == AUX_REG ||
> +               (reg >= BPF_REG_7 && reg <= BPF_REG_9));

please remove extra () around the whole expression, and
align in properly, and
don't move reg==AUX_REG check to a different line.
Subject is not warranted. I don't think it's a simplification.
imo existing code is fine and I don't think the time spent
reviewing such changes is worth it when there is no
improvement in readability.
