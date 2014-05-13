Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbaEMSjq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:39:46 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:57328 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750910AbaEMSjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:39:35 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:965:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:4321:4385:4390:4395:5007:7652:10004:10400:10848:11026:11232:11473:11658:11914:12296:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: price33_36516b40dd809
X-Filterd-Recvd-Size: 1874
Message-ID: <1400006371.24350.45.camel@joe-AO725>
Subject: Re: [PATCH 2/2] fs: print a message when freezing/unfreezing
 filesystems
From: Joe Perches <joe@perches.com>
To: Mateusz Guzik <mguzik@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Josef Bacik <jbacik@fb.com>, Jan Kara <jack@suse.cz>,
        Al Viro <viro@ZenIV.linux.org.uk>, Eric Sandeen <esandeen@redhat.com>
Date: Tue, 13 May 2014 11:39:31 -0700
In-Reply-To: <1400005862-3751-2-git-send-email-mguzik@redhat.com>
References: <1400005862-3751-1-git-send-email-mguzik@redhat.com>
	 <1400005862-3751-2-git-send-email-mguzik@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-05-13 at 20:31 +0200, Mateusz Guzik wrote:
> This helps hang troubleshooting efforts when only dmesg is available.
[]
> diff --git a/fs/super.c b/fs/super.c
[]
> @@ -1289,12 +1289,9 @@ int freeze_super(struct super_block *sb)
>  		return 0;	/* sic - it's "nothing to do" */
>  	}
>  
> -	if (sb->s_flags & MS_RDONLY) {
> +	if (sb->s_flags & MS_RDONLY)
>  		/* Nothing to do really... */
> -		sb->s_writers.frozen = SB_FREEZE_COMPLETE;
> -		up_write(&sb->s_umount);
> -		return 0;
> -	}
> +		goto out;

Should this block really be part of this patch?
If so, please add a small note to the commit log.

I'm not sure making the reader goto out for this
bit of the code needs doing as there are multiple
blocks with return above here.

Trivially, when there is a comment in a single line
like this, then braces are often used too.
 

