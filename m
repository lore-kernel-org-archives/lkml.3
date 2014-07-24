Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934987AbaGXXV3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 19:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751164AbaGXXV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 19:21:28 -0400
Message-ID: <53D194F1.6020603@redhat.com>
Date: Fri, 25 Jul 2014 01:21:21 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alexei Starovoitov <ast@plumgrid.com>
CC: "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: filter: rename 'struct sock_filter_int'
 into 'struct bpf_insn'
References: <1406237179-3713-1-git-send-email-ast@plumgrid.com>
In-Reply-To: <1406237179-3713-1-git-send-email-ast@plumgrid.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 11:26 PM, Alexei Starovoitov wrote:
> eBPF is used by socket filtering, seccomp and soon by tracing and
> exposed to userspace, therefore 'sock_filter_int' name is not accurate.
> Rename it to 'bpf_insn'
>
> Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
> ---
...
>   #define BPF_ALU64_REG(OP, DST, SRC)				\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\

                              ^^^ Please also fix up whitespacing here
                                  and all the other sections below.

>   		.code  = BPF_ALU64 | BPF_OP(OP) | BPF_X,	\
>   		.dst_reg = DST,					\
>   		.src_reg = SRC,					\
> @@ -90,7 +90,7 @@ enum {
>   		.imm   = 0 })
>
>   #define BPF_ALU32_REG(OP, DST, SRC)				\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\
>   		.code  = BPF_ALU | BPF_OP(OP) | BPF_X,		\
>   		.dst_reg = DST,					\
>   		.src_reg = SRC,					\
> @@ -100,7 +100,7 @@ enum {
>   /* ALU ops on immediates, bpf_add|sub|...: dst_reg += imm32 */
>
>   #define BPF_ALU64_IMM(OP, DST, IMM)				\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\
>   		.code  = BPF_ALU64 | BPF_OP(OP) | BPF_K,	\
>   		.dst_reg = DST,					\
>   		.src_reg = 0,					\
> @@ -108,7 +108,7 @@ enum {
>   		.imm   = IMM })
>
>   #define BPF_ALU32_IMM(OP, DST, IMM)				\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\
>   		.code  = BPF_ALU | BPF_OP(OP) | BPF_K,		\
>   		.dst_reg = DST,					\
>   		.src_reg = 0,					\
> @@ -118,7 +118,7 @@ enum {
>   /* Endianess conversion, cpu_to_{l,b}e(), {l,b}e_to_cpu() */
>
>   #define BPF_ENDIAN(TYPE, DST, LEN)				\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\
>   		.code  = BPF_ALU | BPF_END | BPF_SRC(TYPE),	\
>   		.dst_reg = DST,					\
>   		.src_reg = 0,					\
> @@ -128,7 +128,7 @@ enum {
>   /* Short form of mov, dst_reg = src_reg */
>
>   #define BPF_MOV64_REG(DST, SRC)					\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\
>   		.code  = BPF_ALU64 | BPF_MOV | BPF_X,		\
>   		.dst_reg = DST,					\
>   		.src_reg = SRC,					\
> @@ -136,7 +136,7 @@ enum {
>   		.imm   = 0 })
>
>   #define BPF_MOV32_REG(DST, SRC)					\
> -	((struct sock_filter_int) {				\
> +	((struct bpf_insn) {				\
>   		.code  = BPF_ALU | BPF_MOV | BPF_X,		\
>   		.dst_reg = DST,					\
>   		.src_reg = SRC,					\
....
