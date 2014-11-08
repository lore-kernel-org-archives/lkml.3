Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbaKHAjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 19:39:23 -0500
Received: from smtprelay0050.hostedemail.com ([216.40.44.50]:58788 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752699AbaKHAjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 19:39:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:4250:4321:5007:6261:7903:8957:9040:10004:10400:10848:11232:11658:11914:12517:12519:12663:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: truck19_16cf24f54d84c
X-Filterd-Recvd-Size: 1986
Message-ID: <1415407155.23530.24.camel@perches.com>
Subject: Re: [PATCH v5] Move BTRFS RCU string to common library
From: Joe Perches <joe@perches.com>
To: Chris Mason <clm@fb.com>
Cc: Omar Sandoval <osandov@osandov.com>, Josef Bacik <jbacik@fb.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Date: Fri, 07 Nov 2014 16:39:15 -0800
In-Reply-To: <1415391689.9491.0@mail.thefacebook.com>
References: <1415391451-19108-1-git-send-email-osandov@osandov.com>
	 <1415391689.9491.0@mail.thefacebook.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 15:21 -0500, Chris Mason wrote:
> 
> On Fri, Nov 7, 2014 at 3:17 PM, Omar Sandoval <osandov@osandov.com> 
> wrote:
> > The RCU-friendly string API used internally by BTRFS is generic 
> > enough for
> > common use. This doesn't add any new functionality, but instead just 
> > moves the
> > code and documents the existing API.
> > 
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > Signed-off-by: Omar Sandoval <osandov@osandov.com>
> > ---
> > Chris, could you take a look at this again? It's just been rebased 
> > and should
> > be good to go. Thanks!
> 
> Thanks Omar, I'm pulling this into a branch for the next merge window.  
> Looks good to me.

rcustring.h should probably #include any #include dependencies
it has.  types.h, printk.h, etc...


