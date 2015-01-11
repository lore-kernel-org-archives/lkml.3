Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbbAKSwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 13:52:33 -0500
Received: from smtprelay0127.hostedemail.com ([216.40.44.127]:43981 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751085AbbAKSwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 13:52:30 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3865:3867:4321:5007:6261:10004:10400:10848:11232:11658:11914:12043:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: team70_32b1518237e2d
X-Filterd-Recvd-Size: 1238
Message-ID: <1421002345.9233.1.camel@perches.com>
Subject: Re: [PATCH net] packet: bail out of packet_snd() if L2 header
 creation fails
From: Joe Perches <joe@perches.com>
To: Christoph Jaeger <cj@linux.com>, Alan <alan@linux.intel.com>
Cc: davem@davemloft.net, willemb@google.com, edumazet@google.com,
        dborkman@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 11 Jan 2015 10:52:25 -0800
In-Reply-To: <1420999276-28225-1-git-send-email-cj@linux.com>
References: <1420999276-28225-1-git-send-email-cj@linux.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2015-01-11 at 13:01 -0500, Christoph Jaeger wrote:
> Due to a misplaced parenthesis, the expression
> 
>   (unlikely(offset) < 0),
> 
> which expands to
> 
>   (__builtin_expect(!!(offset), 0) < 0),

Here's another one:

drivers/platform/goldfish/goldfish_pipe.c:285:	if (unlikely(bufflen) == 0)


