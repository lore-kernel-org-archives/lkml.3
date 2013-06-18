Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932585Ab3FRPOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:14:45 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:59034 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754995Ab3FRPOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:14:43 -0400
Date: Tue, 18 Jun 2013 11:14:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Dave Kleikamp <dave.kleikamp@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-embedded@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Reduce object size when !CONFIG_PRINTK
Message-ID: <20130618151438.GC7359@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
	Dave Kleikamp <dave.kleikamp@oracle.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-embedded@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
References: <a629c1c6359886419e24179dbb04484a88e6b0f2.1370400427.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a629c1c6359886419e24179dbb04484a88e6b0f2.1370400427.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 04, 2013 at 07:55:05PM -0700, Joe Perches wrote:
> Reduce the object size ~10% could be useful for embedded
> systems.
> 
> Add #ifdef CONFIG_PRINTK #else #endif blocks
> to hold formats and arguments, passing " " to
> functions when !CONFIG_PRINTK and still verifying
> format and arguments with no_printk.
> 
> $ size fs/ext4/built-in.o*
>    text	   data	    bss	    dec	    hex	filename
>  239375	    610	    888	 240873	  3ace9	fs/ext4/built-in.o.new
>  264167	    738	    888	 265793	  40e41	fs/ext4/built-in.o.old
> 
>     $ grep -E "CONFIG_EXT4|CONFIG_PRINTK" .config
>     # CONFIG_PRINTK is not set
>     CONFIG_EXT4_FS=y
>     CONFIG_EXT4_USE_FOR_EXT23=y
>     CONFIG_EXT4_FS_POSIX_ACL=y
>     # CONFIG_EXT4_FS_SECURITY is not set
>     # CONFIG_EXT4_DEBUG is not set
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks.

					- Ted
