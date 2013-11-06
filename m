Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752145Ab3KFXQI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 18:16:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39936 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab3KFXQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 18:16:06 -0500
Date: Wed, 6 Nov 2013 15:16:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, EXT4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH] rbtree/test: test
 rbtree_postorder_for_each_entry_safe()
Message-Id: <20131106151604.c2f85c3463e663cc27fd4eaf@linux-foundation.org>
In-Reply-To: <1383773843-19981-1-git-send-email-cody@linux.vnet.ibm.com>
References: <527AA418.7010009@linux.vnet.ibm.com>
	<1383773843-19981-1-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  6 Nov 2013 13:37:23 -0800 Cody P Schafer <cody@linux.vnet.ibm.com> wrote:

> ...
>
> --- a/lib/rbtree_test.c
> +++ b/lib/rbtree_test.c
> @@ -114,6 +114,16 @@ static int black_path_count(struct rb_node *rb)
>  	return count;
>  }
>  
> +static void check_postorder_foreach(int nr_nodes)
> +{
> +	struct test_node *cur, *n;
> +	int count = 0;
> +	rbtree_postorder_for_each_entry_safe(cur, n, &root, rb)
> +		count++;
> +
> +	WARN_ON_ONCE(count != nr_nodes);
> +}
> +
>  static void check_postorder(int nr_nodes)
>  {
>  	struct rb_node *rb;
> @@ -148,6 +158,7 @@ static void check(int nr_nodes)
>  	WARN_ON_ONCE(count < (1 << black_path_count(rb_last(&root))) - 1);
>  
>  	check_postorder(nr_nodes);
> +	check_postorder_foreach(nr_nodes);
>  }
>  
>  static void check_augmented(int nr_nodes)

I'm rather confused about where this fits with the other (and
apparently withdrawn) patches.

Please resend everything?
