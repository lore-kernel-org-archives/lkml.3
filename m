Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281AbaESOkb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 10:40:31 -0400
Received: from tex.lwn.net ([70.33.254.29]:55808 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbaESOka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 10:40:30 -0400
Date: Mon, 19 May 2014 08:40:28 -0600
From: Jake Edge <jake@lwn.net>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/06] staging: crypto: skein: rename camelcase vars
Message-ID: <20140519084028.1527b066@chukar.edge2.net>
In-Reply-To: <dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
	<abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
	<dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 12:09:55 +0400 Anton Saraev wrote:

>  struct skein_ctx_hdr {
> -	size_t  hashBitLen;		/* size of hash result, in bits */
> -	size_t  bCnt;			/* current byte count in buffer b[] */
> -	u64  T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */
> +	size_t hash_bit_len;		/* size of hash result, in bits */
> +	size_t b_cnt;			/* current byte count in buffer b[] */
> +	u64 T[SKEIN_MODIFIER_WORDS];	/* tweak: T[0]=byte cnt, T[1]=flags */

seems like 'T' should be lower case ... maybe renamed too (tweak?)?

>  struct skein_256_ctx { /* 256-bit Skein hash context structure */
>  	struct skein_ctx_hdr h;		/* common header context variables */
> -	u64  X[SKEIN_256_STATE_WORDS];	/* chaining variables */
> -	u8  b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
> +	u64 X[SKEIN_256_STATE_WORDS];	/* chaining variables */
> +	u8 b[SKEIN_256_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
>  };
>  
>  struct skein_512_ctx { /* 512-bit Skein hash context structure */
>  	struct skein_ctx_hdr h;		/* common header context variables */
> -	u64  X[SKEIN_512_STATE_WORDS];	/* chaining variables */
> -	u8  b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
> +	u64 X[SKEIN_512_STATE_WORDS];	/* chaining variables */
> +	u8 b[SKEIN_512_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
>  };
>  
>  struct skein1024_ctx { /* 1024-bit Skein hash context structure */
>  	struct skein_ctx_hdr h;		/* common header context variables */
> -	u64  X[SKEIN1024_STATE_WORDS];	/* chaining variables */
> -	u8  b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */
> +	u64 X[SKEIN1024_STATE_WORDS];	/* chaining variables */
> +	u8 b[SKEIN1024_BLOCK_BYTES];	/* partial block buf (8-byte aligned) */

the X arrays here should be renamed too, I suspect ...

> @@ -99,8 +99,8 @@ enum skein_size {
>   * structures as well.
>   */
>  struct skein_ctx {
> -	u64 skeinSize;
> -	u64  XSave[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */
> +	u64 skein_size;
> +	u64 X_save[SKEIN_MAX_STATE_WORDS];   /* save area for state variables */

why not x_save?

> -int skein_init(struct skein_ctx *ctx, size_t hashBitLen)
> +int skein_init(struct skein_ctx *ctx, size_t hash_bit_len)
>  {
>  	int ret = SKEIN_FAIL;
> -	size_t Xlen = 0;
> +	size_t X_len = 0;
>  	u64 *X = NULL;

maybe I am missing something, but why not 'x' and 'x_len' ?

> -int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t keyLen,
> -		   size_t hashBitLen)
> +int skein_mac_init(struct skein_ctx *ctx, const u8 *key, size_t key_len,
> +		   size_t hash_bit_len)
>  {
>  	int ret = SKEIN_FAIL;
>  	u64 *X = NULL;
> -	size_t Xlen = 0;
> -	u64 treeInfo = SKEIN_CFG_TREE_INFO_SEQUENTIAL;
> +	size_t X_len = 0;
> +	u64 tree_info = SKEIN_CFG_TREE_INFO_SEQUENTIAL;

and the same here?

>  void skein_reset(struct skein_ctx *ctx)
>  {
> -	size_t Xlen = 0;
> +	size_t X_len = 0;
>  	u64 *X = NULL;

here too ...

> -void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
> -			     size_t blkCnt, size_t byteCntAdd)
> +void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blk_ptr,
> +			     size_t blk_cnt, size_t byte_cnt_add)
>  	{ /* do it in C */
>  	enum {
>  		WCNT = SKEIN_256_STATE_WORDS
> @@ -66,10 +66,11 @@ void skein_256_process_block(struct skein_256_ctx *ctx, const u8 *blkPtr,
>  	u64  X0, X1, X2, X3; /* local copy of context vars, for speed */
>  	u64  w[WCNT]; /* local copy of input block */
>  #ifdef SKEIN_DEBUG
> -	const u64 *Xptr[4]; /* use for debugging (help cc put Xn in regs) */
> -	Xptr[0] = &X0;  Xptr[1] = &X1;  Xptr[2] = &X2;  Xptr[3] = &X3;
> +	const u64 *X_ptr[4]; /* use for debugging (help cc put Xn in regs) */
> +
> +	X_ptr[0] = &X0;  X_ptr[1] = &X1;  X_ptr[2] = &X2;  X_ptr[3] = &X3;

bunch of Xs in through here too ... is X special somehow?  maybe so
because it is used in all that loop-unrolling gunk?

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
