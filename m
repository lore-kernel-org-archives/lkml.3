Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505Ab3JYVDr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 17:03:47 -0400
Received: from smtprelay0170.b.hostedemail.com ([64.98.42.170]:49509 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755364Ab3JYVDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 17:03:46 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::::::::,RULES_HIT:41:152:355:379:582:599:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2692:2693:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4361:5007:6119:6261:6691:7875:7903:8526:8660:10004:10400:10848:10967:11232:11658:11914:12517:12519:12663:12740:13148:13230:13869,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: star49_3896e2947c58
X-Filterd-Recvd-Size: 3418
Date: Fri, 25 Oct 2013 21:03:44 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: neilb@suse.de
Cc: david@lang.hm, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, linux-mm@kvack.org
Message-ID: <476525596.14731.1382735024280.JavaMail.mail@webmail11>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <20131025214952.3eb41201@notabene.brown>
 <alpine.DEB.2.02.1310250425270.22538@nftneq.ynat.uz>
 <154617470.12445.1382725583671.JavaMail.mail@webmail11><20131026074349.0adc9646@notabene.brown>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.147.29.47]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 26, 2013 02:44:07 AM, neil wrote:
On Fri, 25 Oct 2013 18:26:23 +0000 (UTC) "Artem S. Tashkinov"
>> 
>> Exactly. And not being able to use applications which show you IO performance
>> like Midnight Commander. You might prefer to use "cp -a" but I cannot imagine
>> my life without being able to see the progress of a copying operation. With the current
>> dirty cache there's no way to understand how you storage media actually behaves.
>
>So fix Midnight Commander.  If you want the copy to be actually finished when
>it says  it is finished, then it needs to call 'fsync()' at the end.

This sounds like a very bad joke. How applications are supposed to show and
calculate an _average_ write speed if there are no kernel calls/ioctls to actually
make the kernel flush dirty buffers _during_ copying? Actually it's a good way to
solve this problem in user space - alas, even if such calls are implemented, user
space will start using them only in 2018 if not further from that.

>> 
>> Per device dirty cache seems like a nice idea, I, for one, would like to disable it
>> altogether or make it an absolute minimum for things like USB flash drives - because
>> I don't care about multithreaded performance or delayed allocation on such devices -
>> I'm interested in my data reaching my USB stick ASAP - because it's how most people
>> use them.
>>
>
>As has already been said, you can substantially disable  the cache by tuning
>down various values in /proc/sys/vm/.
>Have you tried?

I don't understand who you are replying to. I asked about per device settings, you are
again referring me to system wide settings - they don't look that good if we're talking
about a 3MB/sec flash drive and 500MB/sec SSD drive. Besides it makes no sense
to allocate 20% of physical RAM for things which don't belong to it in the first place.

I don't know any other OS which has a similar behaviour.

And like people (including me) have already mentioned, such a huge dirty cache can
stall their PCs/servers for a considerable amount of time.

Of course, if you don't use Linux on the desktop you don't really care - well, I do. Also
not everyone in this world has an UPS - which means such a huge buffer can lead to a
serious data loss in case of a power blackout.

Regards,

Artem
