Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaFBUWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 16:22:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40884 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbaFBUWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 16:22:18 -0400
Date: Mon, 2 Jun 2014 13:22:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: ocfs2: dir.c:  Cleaning up uninitialized variables
Message-Id: <20140602132216.292fd8363da83b48e90a78ba@linux-foundation.org>
In-Reply-To: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  1 Jun 2014 15:53:04 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> There is a risk that the variable will be used without being initialized.

um, no there isn't.

> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3738,7 +3738,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>  	int credits, ret, i, num_used, did_quota = 0;
>  	u32 cpos, split_hash, insert_hash = hinfo->major_hash;
>  	u64 orig_leaves_start;
> -	int num_dx_leaves;
> +	int num_dx_leaves = 0;
>  	struct buffer_head **orig_dx_leaves = NULL;
>  	struct buffer_head **new_dx_leaves = NULL;
>  	struct ocfs2_alloc_context *data_ac = NULL, *meta_ac = NULL;

If ocfs2_dx_dir_kmalloc_leaves() returns non-zero, num_dx_leaves will
have been initialized.

