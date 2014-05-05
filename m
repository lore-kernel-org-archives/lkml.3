Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbaEEWfu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 18:35:50 -0400
Received: from smtprelay0201.hostedemail.com ([216.40.44.201]:57223 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756645AbaEEWfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 18:35:47 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3870:3871:3874:4321:5007:7652:10004:10400:10848:10967:11026:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: robin37_324c7b145c02a
X-Filterd-Recvd-Size: 2454
Message-ID: <1399329343.27516.2.camel@joe-AO725>
Subject: Re: [PATCH] checkpatch: Improve missing blank line after
 declarations test
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>, devel@driverdev.osuosl.org,
        Seunghun Lee <waydi1@gmail.com>, linux-kernel@vger.kernel.org
Date: Mon, 05 May 2014 15:35:43 -0700
In-Reply-To: <20140505151531.af8e82be3a0c4800f0051de2@linux-foundation.org>
References: <1398790752-8067-1-git-send-email-waydi1@gmail.com>
	 <20140429173221.GE26890@mwanda> <20140503234326.GA30117@kroah.com>
	 <20140505095935.GO26890@mwanda> <1399319468.26330.2.camel@joe-AO725>
	 <1399320736.26330.8.camel@joe-AO725>
	 <20140505151531.af8e82be3a0c4800f0051de2@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-05 at 15:15 -0700, Andrew Morton wrote:
> On Mon, 05 May 2014 13:12:16 -0700 Joe Perches <joe@perches.com> wrote:
> 
> > A couple more modifications to the declarations tests.
> > 
> > o Declarations can also be bitfields so exclude things with a colon
> > o Make sure the current and previous lines are indented the same
> >   to avoid matching some macro where a struct type is passed on
> >   the previous line like:
> > 
> > 		next = list_entry(buffer->entry.next,
> > 				  struct binder_buffer, entry);
> > 		if (buffer_start_page(next) == buffer_end_page(buffer)) 
> 
> So checkpatch-always-warn-on-missing-blank-line-after-variable-declaration-block.patch
> is stuck in -mm while I evaluate its effects.  Thus far that evaluation
> has been "super non-intrusive", because the patch doesn't actually
> do anything.
[]
> @@ -67,6 +68,7 @@ long vfs_truncate(struct path *path, lof
>  {
>  	struct inode *inode;
>  	long error;
> +	wobble();
>  
>  	inode = path->dentry->d_inode;

Patch content can be a bit odd when lines are
both added and deleted so checkpatch bleats
only when both lines are added.

+	int foo;
+	wibble();

generates a complaint.

 	int foo;
+	wibble_wobble();

does not.

