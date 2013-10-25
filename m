Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754948Ab3JYS02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 14:26:28 -0400
Received: from smtprelay0123.b.hostedemail.com ([64.98.42.123]:56249 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752703Ab3JYS01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 14:26:27 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::,RULES_HIT:41:152:355:379:582:599:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2690:2692:2693:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4361:5007:6261:7875:7903:8526:8957:10004:10400:10450:10455:10848:11232:11658:11914:12517:12519:12663:12740:13069:13160:13229:13311:13357:13869:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jar43_54f05e920e923
X-Filterd-Recvd-Size: 2404
Date: Fri, 25 Oct 2013 18:26:23 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: david@lang.hm
Cc: neilb@suse.de, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, linux-mm@kvack.org
Message-ID: <154617470.12445.1382725583671.JavaMail.mail@webmail11>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <20131025214952.3eb41201@notabene.brown><alpine.DEB.2.02.1310250425270.22538@nftneq.ynat.uz>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.147.29.47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 25, 2013 05:26:45 PM, david wrote:
On Fri, 25 Oct 2013, NeilBrown wrote:
>
>>
>> What exactly is bothering you about this?  The amount of memory used or the
>> time until data is flushed?
>
>actually, I think the problem is more the impact of the huge write later on.

Exactly. And not being able to use applications which show you IO performance
like Midnight Commander. You might prefer to use "cp -a" but I cannot imagine
my life without being able to see the progress of a copying operation. With the current
dirty cache there's no way to understand how you storage media actually behaves.

Hopefully this issue won't dissolve into obscurity and someone will actually make
up a plan (and a patch) how to make dirty write cache behave in a sane manner
considering the fact that there are devices with very different write speeds and
requirements. It'd be ever better, if I could specify dirty cache as a mount option
(though sane defaults or semi-automatic values based on runtime estimates
won't hurt).

Per device dirty cache seems like a nice idea, I, for one, would like to disable it
altogether or make it an absolute minimum for things like USB flash drives - because
I don't care about multithreaded performance or delayed allocation on such devices -
I'm interested in my data reaching my USB stick ASAP - because it's how most people
use them.

Regards,

Artem
