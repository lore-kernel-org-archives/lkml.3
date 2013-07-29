Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540Ab3G2SCT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 14:02:19 -0400
Received: from smtprelay0114.b.hostedemail.com ([64.98.42.114]:54591 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751999Ab3G2SCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 14:02:17 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::::,RULES_HIT:152:355:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2560:2563:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6261:6691:8599:9025:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12555:12698:12737:12740:12926:13025:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: duck84_883a6507eba24
X-Filterd-Recvd-Size: 1833
Date: Mon, 29 Jul 2013 18:02:16 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: eric.dumazet@gmail.com
Cc: stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Message-ID: <2134648871.43175.1375120936132.JavaMail.mail@webmail09>
References: <2066879158.39771.1375110634453.JavaMail.mail@webmail09>
 <20130729083519.5d574f16@nehalam.linuxnetplumber.net>
 <2063167407.40450.1375112877907.JavaMail.mail@webmail09><1375119778.10515.20.camel@edumazet-glaptop>
Subject: Re: A call to revise sockets behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.189.148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jul 29, 2013 11:43:00 PM, Eric wrote:
On Mon, 2013-07-29 at 15:47 +0000, Artem S. Tashkinov wrote:
>
>> A wine developer clearly showed that this option simply doesn't work. 
>> 
>> http://bugs.winehq.org/show_bug.cgi?id=26031#c21
>> 
>> Output of strace:
>> getsockopt(24, SOL_SOCKET, SO_REUSEADDR, [0], [4]) = 0
>> setsockopt(24, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
>> bind(24, {sa_family=AF_INET, sin_port=htons(43012), sin_addr=inet_addr("0.     
>> 0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)
>
>Its clear that some other socket did not use SO_REUSADDR
>
>All sockets using a given port _must_ have use SO_REUSADDR to allow this
>port being reused.
>

It's exactly what's been tried. A program running with SO_REUSADDR, once no longer
running consequently fails to regain the rights for the port.
