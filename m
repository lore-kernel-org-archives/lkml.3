Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbaBWUoy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 15:44:54 -0500
Received: from smtprelay0175.hostedemail.com ([216.40.44.175]:50283 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751237AbaBWUow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 15:44:52 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:960:988:989:1028:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4321:4605:5007:7652:8784:10004:10400:10848:11026:11232:11473:11658:11914:12438:12517:12519:12555:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: north04_2a54a012be520
X-Filterd-Recvd-Size: 2113
Message-ID: <1393188288.11020.9.camel@joe-AO722>
Subject: Re: [RFC] improve_stack: make stack dump output useful again
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <sasha.levin@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sun, 23 Feb 2014 12:44:48 -0800
In-Reply-To: <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
References: <1393114777-21588-1-git-send-email-sasha.levin@oracle.com>
	 <CA+55aFxPL9dWAK-y0tDFj5r6ikKytqnxL3A+9KH55GpmCQFf9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-23 at 12:27 -0800, Linus Torvalds wrote:
> So I would *really* want to do this kernel change (possibly
> conditional on RANDOMIZE_BASE_ADDRESS or whatever the config variable
> is called):
> 
>     diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
>     index d9c12d3022a7..58039e728f00 100644
>     --- a/arch/x86/kernel/dumpstack.c
>     +++ b/arch/x86/kernel/dumpstack.c
>     @@ -27,13 +27,12 @@ static int die_counter;
> 
>      static void printk_stack_address(unsigned long address, int reliable)
>      {
>     -       pr_cont(" [<%p>] %s%pB\n",
>     -               (void *)address, reliable ? "" : "? ", (void *)address);
>     +       pr_cont(" %s[<%pB>]\n", reliable ? "" : "? ", (void *)address);
>      }
> 
>      void printk_address(unsigned long address)
>      {
>     -       pr_cont(" [<%p>] %pS\n", (void *)address, (void *)address);
>     +       pr_cont(" [<%pS>]\n", (void *)address);
>      }
> 
>      #ifdef CONFIG_FUNCTION_GRAPH_TRACER

I'd rather see this as a vsprintf extension so
that it is more difficult to interleave and
doesn't need to be replicated for each arch.


