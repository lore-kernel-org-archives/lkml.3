Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596AbaIWRqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:46:10 -0400
Received: from ducie-dc1.codethink.co.uk ([185.25.241.215]:46622 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755687AbaIWRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:46:08 -0400
Message-ID: <1411494387.32579.138.camel@xylophone>
Subject: Re: [Linux-kernel] [PATCH v2] net/netfilter/x_tables.c: use
 __seq_open_private()
From: Ben Hutchings <ben.hutchings@codethink.co.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: davem@davemloft.net, coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@codethink.co.uk, linux-kernel@vger.kernel.org,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Date: Tue, 23 Sep 2014 18:46:27 +0100
In-Reply-To: <1411491955-9131-1-git-send-email-rob.jones@codethink.co.uk>
References: <1411491955-9131-1-git-send-email-rob.jones@codethink.co.uk>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-23 at 18:05 +0100, Rob Jones wrote:
> Reduce boilerplate code by using __seq_open_private() instead of seq_open()
> in xt_match_open() and xt_target_open().
> 
> Signed-off-by: Rob Jones <rob.jones@codethink.co.uk>
> ---
> 
> This patch uses an existing variant of seq_open() to reduce the kernel code
> size.
> 
> The only significant variation from the pre-existing code is the fact that
> __seq_open_private() calls kzalloc() rather than kmalloc(), which could
> conceivably have an impact on timing.
> 
> This version 2 incorporates a minor initialisation simplification (resulting
> from kzalloc() being used) requested by netfilter-devel@vger.kernel.org
[...]
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1080,7 +1080,6 @@ static void *xt_mttg_seq_start(struct seq_file *seq, loff_t *pos,
>         struct nf_mttg_trav *trav = seq->private;
>         unsigned int j;
>  
> -       trav->class = MTTG_TRAV_INIT;
>         for (j = 0; j < *pos; ++j)
>                 if (xt_mttg_seq_next(seq, NULL, NULL, is_target) == NULL)
>                         return NULL;
[...]

I'm fairly sure this simplification is wrong, as xt_mttg_seq_start() is
potentially called multiple times on the same file handle.

Ben.


