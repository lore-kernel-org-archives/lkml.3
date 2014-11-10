Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaKJP1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 10:27:01 -0500
Received: from smtprelay0019.hostedemail.com ([216.40.44.19]:60295 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752895AbaKJP07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 10:26:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:5007:6119:6120:6261:6691:7808:7903:9389:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12740:13069:13311:13357:13894:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: sky65_1f870758cc617
X-Filterd-Recvd-Size: 2498
Message-ID: <1415633215.8868.4.camel@perches.com>
Subject: Re: [RFC PATCH net-next] net: Convert LIMIT_NETDEBUG to
 net_dbg_ratelimited
From: Joe Perches <joe@perches.com>
To: nicolas.dichtel@6wind.com
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Remi Denis-Courmont <courmisch@gmail.com>
Date: Mon, 10 Nov 2014 07:26:55 -0800
In-Reply-To: <5460CB43.4050008@6wind.com>
References: <1415230929.6634.38.camel@perches.com>
	 <20141106.151149.1321164537677873976.davem@davemloft.net>
	 <1415307221.21526.0.camel@perches.com>
	 <20141108.204202.2273082249078358608.davem@davemloft.net>
	 <1415560642.23530.43.camel@perches.com> <5460CB43.4050008@6wind.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-10 at 15:27 +0100, Nicolas Dichtel wrote:
> Le 09/11/2014 20:17, Joe Perches a écrit :
> > Use the more common dynamic_debug capable net_dbg_ratelimited
> > and remove the LIMIT_NETDEBUG macro.
> >
> > This may have some negative impact on messages that were
> > emitted at KERN_INFO that are not not enabled at all unless
> > DEBUG is defined or dynamic_debug is enabled.  Even so,
> > these messages are now _not_ emitted by default.
> >
> > This eliminates the use of the net_msg_warn sysctl
> > "/proc/sys/net/core/warnings".
[]
> > diff --git a/include/net/sock.h b/include/net/sock.h
[]
> > @@ -2276,13 +2276,7 @@ bool sk_ns_capable(const struct sock *sk,
> >   bool sk_capable(const struct sock *sk, int cap);
> >   bool sk_net_capable(const struct sock *sk, int cap);
> >
> > -/*
> > - *	Enable debug/info messages
> > - */
> > -extern int net_msg_warn;
> > -#define LIMIT_NETDEBUG(fmt, args...) \
> > -	do { if (net_msg_warn && net_ratelimit()) printk(fmt,##args); } while(0)
> > -
> > +extern int net_msg_warn;	/* Unused, but still a sysctl */
> Why not removing this variable from this header and from net/core/utils.c?
> Just declaring a static variable in net/core/sysctl_net_core.c should be enough.
> Am I missing something?

No.  It's reasonable to remove its EXPORT_SYMBOL use too.

First let's see if there are any objections to the removal.


