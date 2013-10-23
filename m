Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751307Ab3JWGML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 02:12:11 -0400
Received: from smtprelay0156.b.hostedemail.com ([64.98.42.156]:35193 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751201Ab3JWGMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 02:12:10 -0400
X-Greylist: delayed 526 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Oct 2013 02:12:10 EDT
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:,RULES_HIT:41:152:355:379:582:966:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2196:2199:2200:2393:2525:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3308:3352:3421:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4361:4385:5007:6119:6261:6630:6691:7875:7903:8603:9025:9108:10004:10400:10450:10455:10848:11658:11914:12043:12517:12519:12555:12663:12698:12737:13069:13071:13160:13161:13166:13229:13311:13357:19904:19999,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: mist77_1d46700ef4457
X-Filterd-Recvd-Size: 1972
Date: Wed, 23 Oct 2013 06:03:21 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: linux-kernel@vger.kernel.org
Message-ID: <707282746.213759.1382508201161.JavaMail.mail@webmail01>
Subject: Disabling in-memory write cache for x86-64 in Linux 3.11
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [79.141.59.82]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On my x86-64 PC (Intel Core i5 2500, 16GB RAM), I have the same 3.11 kernel
built for the i686 (with PAE) and x86-64 architectures. What's really troubling me
is that the x86-64 kernel has the following problem:

When I copy large files to any storage device, be it my HDD with ext4 partitions
or flash drive with FAT32 partitions, the kernel first caches them in memory entirely
then flushes them some time later (quite unpredictably though) or immediately upon
running "sync".

How can I disable this memory cache altogether? When running the i686 kernel with
the same configuration I don't observe this effect - files get written out almost immediately
(for instance "sync" takes less than a second, whereas on x86-64 it can take a dozen of
_minutes_ depending on a file size and storage performance).

I'm _not_ talking about disabling write cache on my storage itself (hdparm -W 0 /dev/XXX)
- firstly this command is detrimental to the performance of my PC, secondly, it won't help
in this instance.

Swap is totally disabled, usually my memory is entirely free.

My kernel configuration can be fetched here: https://bugzilla.kernel.org/show_bug.cgi?id=63531

Please, advise.

Best regards,

Artem
