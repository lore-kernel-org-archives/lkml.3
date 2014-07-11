Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaGKUhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:37:07 -0400
Received: from smtprelay0047.hostedemail.com ([216.40.44.47]:48080 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752871AbaGKUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:37:06 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2525:2560:2563:2682:2685:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3350:3622:3743:3865:3866:3867:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7652:8985:9025:10004:10400:10848:11026:11232:11473:11658:11914:12043:12517:12519:12740:13069:13095:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,S
X-HE-Tag: brake82_35ba29fddd0e
X-Filterd-Recvd-Size: 1576
Message-ID: <1405111021.2796.23.camel@joe-AO725>
Subject: Re: [PATCH 1/1] rcutorture: fixes for printing message buffer
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Josh Triplett <josh@freedesktop.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Iulia Manda <iulia.manda21@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Date: Fri, 11 Jul 2014 13:37:01 -0700
In-Reply-To: <1405110617-16498-1-git-send-email-bobby.prani@gmail.com>
References: <1405110617-16498-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-11 at 16:30 -0400, Pranith Kumar wrote:
> Use snprintf() instead of sprintf() for writing to the message buffer.
> Also use vmalloc() for the allocation of the message buffer. Since pr_alert() is
> limited to print LOG_LINE_MAX characters at a time, we print the buffer in a
> loop one line at a time.
> 
> I tested this using the parse-torture.sh script as follows:

Did you see the patch I sent you?
https://lkml.org/lkml/2014/6/20/604

It doesn't need a vmalloc.
What is wrong with that approach?


