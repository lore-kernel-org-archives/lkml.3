Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3G2PsB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 11:48:01 -0400
Received: from smtprelay0153.b.hostedemail.com ([64.98.42.153]:42116 "EHLO
	smtprelay.b.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755770Ab3G2Pr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 11:47:59 -0400
X-Session-Marker: 742E617274656D406C79636F732E636F6D
X-Panda: scanned!
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,t.artem@lycos.com,:::::,RULES_HIT:152:355:379:582:599:967:973:988:989:1152:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2525:2553:2565:2682:2685:2689:2692:2693:2731:2736:2859:2894:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:5007:6119:6261:6691:7775:7903:8526:8599:8985:9025:10004:10400:10848:10967:11232:11658:11914:12043:12296:12517:12519:12555:12663:12679:12682:12698:12737:12740:12926:13025:13618:13868,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rice17_7fc18f1e9ee23
X-Filterd-Recvd-Size: 3675
Date: Mon, 29 Jul 2013 15:47:57 +0000 (UTC)
From: "Artem S. Tashkinov" <t.artem@lycos.com>
To: stephen@networkplumber.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-ID: <2063167407.40450.1375112877907.JavaMail.mail@webmail09>
References: <2066879158.39771.1375110634453.JavaMail.mail@webmail09><20130729083519.5d574f16@nehalam.linuxnetplumber.net>
Subject: Re: A call to revise sockets behaviour
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.146.189.148]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jul 29, 2013 09:35:25 PM, Stephen wrote:
On Mon, 29 Jul 2013 15:10:34 +0000 (UTC)
>"Artem S. Tashkinov" wrote:
>
>> Hello,
>> 
>> Currently the Linux kernel disallows to start listening on a TCP/UDP socket if
>> there are open connections against the port, regardless connections status. So even
>> if _all_ you have is some stale (i.e. no longer active connections pending destruction)
>> the kernel will not allow to reuse this socket.
>> 
>> Stephen Hemminger argues that this behaviour is expected even though it's 100%
>> counter productive, it defies common sense and I cannot think of any security implications
>> should this feature be allowed.
>> 
>> Besides, when discussing this bug on Wine's bugzilla I have shown that this behavior not
>> only affect Windows applications running under Wine, but also native POSIX applications.
>> 
>> If nothing else is listening to incoming connections how can _old_ _stale_ connections
>> prevent an application from listening on the port? Windows has no qualms about allowing
>> that, why the Linux kernel works differently?
>> 
>> I want to hear how the current apparently _broken_ behaviour, "The current socket API
>> behavior is unlikely to be changed because so many applications expect it", can be expected.
>> 
>> Also I'd like to know which applications depend on this "feature".
>> 
>> Imagine a situation,
>> 
>> You have an apache server serving connections on port 80. For some reasons a crash in
>> one of its modules causes the daemon crash but during the crash Apache had some open
>> connections on this port.
>> 
>> According to Stephen Hemminger I cannot relaunch Apache until the kernel waits arbitrary
>> time in order to clean stale connections for its networking pool.
>> 
>> I fail to see how this behaviour can be "expected".
>> 
>> More on it here:
>> 
>> https://bugzilla.kernel.org/show_bug.cgi?id=45571
>> http://bugs.winehq.org/show_bug.cgi?id=26031
>
>I understand your problem, people have been having to deal with it for 30 years.
>The attitude in your response makes it seem like you just discovered fire,
>read a book like Steven's network programming if you need more info.
>
>If you don't use SO_REUSEADDR then yes application has to wait for time wait
>period.
>
>If you do enable SO_REUSEADDR then it is possible to bind to a port with existing
>stale connections.
>

A wine developer clearly showed that this option simply doesn't work. 

http://bugs.winehq.org/show_bug.cgi?id=26031#c21

Output of strace:
getsockopt(24, SOL_SOCKET, SO_REUSEADDR, [0], [4]) = 0
setsockopt(24, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
bind(24, {sa_family=AF_INET, sin_port=htons(43012), sin_addr=inet_addr("0.     
0.0.0")}, 16) = -1 EADDRINUSE (Address already in use)

Artem
