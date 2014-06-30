Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaF3Ute (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 16:49:34 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:57200 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751110AbaF3Utd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 16:49:33 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:4321:5007:6119:6120:7652:8603:10004:10400:10848:10967:11026:11232:11658:11914:12296:12438:12517:12519:12555:12663:12740:13069:13311:13357:14040:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bike05_3607ab497cc0f
X-Filterd-Recvd-Size: 1889
Message-ID: <1404161370.2717.10.camel@joe-AO725>
Subject: Re: [RFC 1/1] proc: constify seq_operations
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
Date: Mon, 30 Jun 2014 13:49:30 -0700
In-Reply-To: <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
References: <1404154997-15490-1-git-send-email-fabf@skynet.be>
	 <20140630133939.c24cd71919cd28c90992d6e1@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-30 at 13:39 -0700, Andrew Morton wrote:
> On Mon, 30 Jun 2014 21:03:17 +0200 Fabian Frederick <fabf@skynet.be> wrote:
> 
> > proc_uid_seq_operations, proc_gid_seq_operations and proc_projid_seq_operations
> > are only called in proc_id_map_open with seq_open as
> > const struct seq_operations so we can constify the 3 structures and update
> > proc_id_map_open prototype.
> 
> There are an absolutely enormous number of places where we could
> constify things.

Which would be a good thing.

>   For sheer sanity's sake I'm not inclined to churn the
> code in this way unless a patch provides some sort of runtime benefit. 
> And this particular patch doesn't appear to change the generated code
> at all.

It moves ~100 bytes from data to text
(gcc 4.8)

$ size kernel/user_namespace.o*
   text	   data	    bss	    dec	    hex	filename
   6676	   3107	   2248	  12031	   2eff	kernel/user_namespace.o.new
   6580	   3211	   2248	  12039	   2f07	kernel/user_namespace.o.old


