Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbaKRJQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 04:16:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753631AbaKRJQE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 04:16:04 -0500
Date: Tue, 18 Nov 2014 10:16:02 +0100
From: Jan Kara <jack@suse.cz>
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH 1/1] fs-jbd: Deletion of an unnecessary check before the
 function call "iput"
Message-ID: <20141118091602.GB19318@quack.suse.cz>
References: <530C5E18.1020800@users.sourceforge.net>
 <alpine.DEB.2.10.1402251014170.2080@hadrien>
 <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <546927D2.7050709@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546927D2.7050709@users.sourceforge.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 16-11-14 23:40:18, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sun, 16 Nov 2014 23:23:19 +0100
> 
> The iput() function tests whether its argument is NULL and then
> returns immediately. Thus the test around the call is not needed.
> 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/jbd/journal.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
  Thanks. Merged into my tree.

								Honza

> 
> diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
> index 06fe11e..32fe03e 100644
> --- a/fs/jbd/journal.c
> +++ b/fs/jbd/journal.c
> @@ -1373,8 +1373,7 @@ int journal_destroy(journal_t *journal)
>  	}
>  	mutex_unlock(&journal->j_checkpoint_mutex);
>  
> -	if (journal->j_inode)
> -		iput(journal->j_inode);
> +	iput(journal->j_inode);
>  	if (journal->j_revoke)
>  		journal_destroy_revoke(journal);
>  	kfree(journal->j_wbuf);
> -- 
> 2.1.3
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
