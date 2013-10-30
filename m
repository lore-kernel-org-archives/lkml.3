Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3J3KHM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 06:07:12 -0400
Received: from smtprelay0030.b.hostedemail.com ([64.98.42.30]:60166 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753721Ab3J3KHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 06:07:10 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::::::,RULES_HIT:41:152:355:379:582:599:966:968:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2693:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4250:4321:4385:5007:6119:6261:7875:7903:10004:10400:10450:10455:10848:11026:11232:11658:11914:12043:12438:12517:12519:12740:13069:13161:13229:13311:13357:13618:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cart46_5b7963ac93e24
X-Filterd-Recvd-Size: 2801
Date: Wed, 30 Oct 2013 10:07:08 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: jack@suse.cz
Cc: tytso@mit.edu, fengguang.wu@intel.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        diegocg@gmail.com, david@lang.hm, neilb@suse.de
Message-ID: <1532891663.73423.1383127628582.JavaMail.mail@webmail14>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org> <20131025230545.GB31280@localhost>
 <20131025233753.GD19823@thunk.org><20131029204052.GF9568@quack.suse.cz>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.117.87]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 30, 2013 02:41:01 AM, Jack wrote:
On Fri 25-10-13 19:37:53, Ted Tso wrote:
>> Sure, although I wonder if it would be worth it calcuate some kind of
>> rolling average of the write bandwidth while we are doing writeback,
>> so if it turns out we got unlucky with the contents of the first 100MB
>> of dirty data (it could be either highly random or highly sequential)
>> the we'll eventually correct to the right level.
>  We already do average measured throughput over a longer time window and
>have kind of rolling average algorithm doing some averaging.
>
>> This means that VM would have to keep dirty page counters for each BDI
>> --- which I thought we weren't doing right now, which is why we have a
>> global vm.dirty_ratio/vm.dirty_background_ratio threshold.  (Or do I
>> have cause and effect reversed?  :-)
>  And we do currently keep the number of dirty & under writeback pages per
>BDI. We have global limits because mm wants to limit the total number of dirty
>pages (as those are harder to free). It doesn't care as much to which device
>these pages belong (although it probably should care a bit more because
>there are huge differences between how quickly can different devices get rid
>of dirty pages).

This might sound like an absolutely stupid question which makes no sense at
all, so I want to apologize for it in advance, but since the Linux kernel lacks
revoke(), does that mean that dirty buffers will always occupy the kernel memory
if I for instance remove my USB stick before the kernel has had the time to flush
these buffers?
