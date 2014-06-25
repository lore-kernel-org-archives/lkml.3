Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaFYLWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:22:47 -0400
Received: from smtprelay0167.hostedemail.com ([216.40.44.167]:50637 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752683AbaFYLWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:22:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3871:3872:4321:5007:6120:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: grip03_34a514378fe42
X-Filterd-Recvd-Size: 2877
Message-ID: <1403695360.17451.32.camel@joe-AO725>
Subject: Re: [RFC PATCH 0/3] Mark literal strings in __init / __exit code
From: Joe Perches <joe@perches.com>
To: Mathias Krause <minipli@googlemail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 25 Jun 2014 04:22:40 -0700
In-Reply-To: <CA+rthh83g7W2UVbGGENmTOtamRoQvo_UD_04C2Ux5fAhvX2b9Q@mail.gmail.com>
References: <1403477209-14612-1-git-send-email-minipli@googlemail.com>
	 <1403477762.18747.14.camel@joe-AO725>
	 <CA+rthh8D=r1kW6iDb0MqfHwA4OW-oXSA+B1AXe-0Cqperz6ZRQ@mail.gmail.com>
	 <1403505219.18747.37.camel@joe-AO725> <87egyeqt03.fsf@rasmusvillemoes.dk>
	 <CA+rthh8XwC80hq8z07k+=0J7MDA6tUtLff+J=qMuzYqTNyLKww@mail.gmail.com>
	 <1403638620.29061.35.camel@joe-AO725>
	 <CA+rthh9qGpkicfR+C7Qz1uOF4HUaVANVyq6YaH_Rx-80L_-YvQ@mail.gmail.com>
	 <1403641843.29061.51.camel@joe-AO725>
	 <CA+rthh89rYOyUd58vJO_0Nu_j+zrAMwUYSitRbT=MVoz9pO5Lw@mail.gmail.com>
	 <1403643440.29061.56.camel@joe-AO725>
	 <CA+rthh9gKVWix4E0ENPFBXgUMpjnb8_+aeNUi3iZpAnqzo8C1w@mail.gmail.com>
	 <1403646310.29061.61.camel@joe-AO725>
	 <CA+rthh8anKnxA7XuZb4BHB4a7w=Oo3LhUuD2UOwGfv2SGxLs0w@mail.gmail.com>
	 <877g45qw53.fsf@rasmusvillemoes.dk> <1403682511.17451.21.camel@joe-AO725>
	 <CA+rthh83g7W2UVbGGENmTOtamRoQvo_UD_04C2Ux5fAhvX2b9Q@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-25 at 10:34 +0200, Mathias Krause wrote:
> On 25 June 2014 09:48, Joe Perches <joe@perches.com> wrote:
> > On Wed, 2014-06-25 at 09:35 +0200, Rasmus Villemoes wrote:
> >> Speaking of dangling pointers: A similar disaster would happen if some
> >> code containing pi_* calls gets copy-pasted to some non-__init
> >> function.
> >
> > This is my biggest issue with adding these new,
> > somewhat obscure macros.
> 
> modpost will handle these cases.

If so, then I don't see a problem.

> >> Could checkpatch learn to warn about calling these functions
> >> from the wrong context?
> >
> > It's not possible.  checkpatch works on patch chunks.
> > Any patch chunk may not contain the function attributes.
> 
> checkpatch.pl -f might detect them, though :/

Something like your awk script would be easier.


