Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936AbbAZUoZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 15:44:25 -0500
Received: from smtprelay0052.hostedemail.com ([216.40.44.52]:50893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753120AbbAZUoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 15:44:22 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2553:2559:2562:3138:3139:3140:3141:3142:3350:3622:3865:3866:3867:3868:3870:3871:3874:5007:6261:7875:10004:10400:10848:10967:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boot25_8d3025e8cb2d
X-Filterd-Recvd-Size: 1554
Date: Mon, 26 Jan 2015 15:44:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/16 v3] tracing: Add new file system tracefs
Message-ID: <20150126154419.409e7138@gandalf.local.home>
In-Reply-To: <20150126154259.5e650d32@gandalf.local.home>
References: <20150126150913.653681560@goodmis.org>
	<20150126193049.GN29656@ZenIV.linux.org.uk>
	<20150126154259.5e650d32@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015 15:42:59 -0500
Steven Rostedt <rostedt@goodmis.org> wrote:

  
> -	if (IS_ERR(dentry))
> +struct dentry *tracefs_create_instance_dir(const char *name, struct dentry *parent,
> +					  int (*mkdir)(const char *name),
> +					  int (*rmdir)(const char *name))

Now what I could also do is to only allow this to be called once. And
in that case, we can hard code what mkdir and rmdir are. This could
work as currently there only exists a single instance of the instances
directory.

I might just do that too.

-- Steve

