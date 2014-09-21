Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaIUPxL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 11:53:11 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:37306 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751204AbaIUPxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 11:53:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:967:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6248:7652:8603:8957:9025:10004:10400:10848:10967:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mask28_7279fc7520f28
X-Filterd-Recvd-Size: 2484
Message-ID: <1411314785.2952.8.camel@joe-AO725>
Subject: Re: [PATCH v2 1/2] Return a value from printk_ratelimited
From: Joe Perches <joe@perches.com>
To: paulmck@linux.vnet.ibm.com, Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: Steven Rostedt <rostedt@goodmis.org>, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Date: Sun, 21 Sep 2014 08:53:05 -0700
In-Reply-To: <20140921132512.GI4723@linux.vnet.ibm.com>
References: <cover.1411116672.git.osandov@osandov.com>
	 <3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
	 <20140919132123.418b276f@gandalf.local.home>
	 <1411150553.24444.29.camel@joe-AO725>
	 <20140921132512.GI4723@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-09-21 at 06:25 -0700, Paul E. McKenney wrote:
> On Fri, Sep 19, 2014 at 11:15:53AM -0700, Joe Perches wrote:
> > On Fri, 2014-09-19 at 13:21 -0400, Steven Rostedt wrote:
> > > On Fri, 19 Sep 2014 02:01:29 -0700
> > > Omar Sandoval <osandov@osandov.com> wrote:
> > > 
> > > > printk returns an integer; there's no reason for printk_ratelimited to swallow
> > > > it.
> > 
> > Except for the lack of usefulness of the return value itself.
> > See: https://lkml.org/lkml/2009/10/7/275
> 
> When printk()'s return value is changed to void, then yes, we should
> clearly change this code to match that.
> 
> So, I have to ask...  What happened to the patch later in that series
> that was to remove the uses of the printk() return value?

I don't know.

Last I recall via searching emails, Alan Jenkins was going to do
something with it. (I've added his old email to this reply, but
I doubt still works)

I remember checking whether or not the removing the return value
reduced the code size on x86 (it did not), and forgot about it.

I don't know if removing the printk return value reduces overall
image size in any arch, so I didn't pursue it.

