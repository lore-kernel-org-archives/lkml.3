Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaBTSB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:01:26 -0500
Received: from mail-qa0-f54.google.com ([209.85.216.54]:61542 "EHLO
	mail-qa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbaBTSBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:01:24 -0500
Date: Thu, 20 Feb 2014 13:03:16 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Peter Zijlstra <peterz@infradead.org>
cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: x86_pmu_start WARN_ON.
In-Reply-To: <20140220100830.GN6835@laptop.programming.kicks-ass.net>
Message-ID: <alpine.DEB.2.10.1402201302150.24360@vincent-weaver-1.um.maine.edu>
References: <20140211132956.GY9987@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402121559350.20738@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402130910520.22057@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402131234160.22113@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1402131700090.24354@vincent-weaver-1.um.maine.edu> <20140217152859.GF15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402181327400.31682@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1402181717300.20073@vincent-weaver-1.um.maine.edu>
 <20140219101949.GG15586@twins.programming.kicks-ass.net> <alpine.DEB.2.10.1402191727420.23543@vincent-weaver-1.um.maine.edu> <20140220100830.GN6835@laptop.programming.kicks-ass.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1893821626-1392919404=:24360"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1893821626-1392919404=:24360
Content-Type: TEXT/PLAIN; charset=US-ASCII

On Thu, 20 Feb 2014, Peter Zijlstra wrote:

> On Wed, Feb 19, 2014 at 05:34:49PM -0500, Vince Weaver wrote:
> > So where would the NMI counter event get disabled?  Would it never get 
> > disabled, just because it's always running and always gets the same fixed 
> > slot?  Why isn't this a problem all the time, not just with corner cases?
> 
> Well it could get another counter assignment I suppose; there's no
> guarantee it always ends up in the fixed counter although that's rather
> likely.
> 
> > Is somehow n_added getting confused?
> 
> I'd expect worse than a warning if that happened, but who knows.
> 
> You could try with the below; make sure you've got CONFIG_FUNCTION_TRACER=y.

> # cat /debug/tracing/trace | bzip2 -9 > ~/trace.bz2
> 
> And send that (and look at it of course).

attached, it's not very big.  

Vince
--8323329-1893821626-1392919404=:24360
Content-Type: APPLICATION/octet-stream; name=trace.bz2
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.10.1402201303160.24360@vincent-weaver-1.um.maine.edu>
Content-Description: 
Content-Disposition: attachment; filename=trace.bz2

QlpoOTFBWSZTWfmSc7QACNz/gGuUAHBIZ//zLyveCr/n/+5gCYwfH3yzLbPr
bQ6cvW2PdfcDt97tqJKpYbUp6KTQNoIwmgNMgyMBGTIBppkyDEAURKAGIDQA
BgTQAMjQBo2ohVMQaDRoAAAyAYgAAaCU/VQlTUMgANAAAAAA0DQAE1SUSegU
9qmnojDRAAyMAJoaNB6gwFKURPRBJ+oamJoNpAyABo0aAA0DYqJlBAqUrMAs
kcuzj28ju7KDyPB3T8tdoxipIuJzgaqgToFVA20wZq6FVgTFDXVoE9ZJxZnA
OaGUCMLV3adg5zmhVYIlUNFAjGZu7TskWc0KrBExQ0aCDOpzOMYh4CHORxVB
DlKhxVAneZzdxjAOdaoi7BOggoY5hgw+3H59fj57fXXL2xKFMREQ6/HnddiN
q7vlSu/BzYkMZBaQfJ7VUHDnKU83vVQaVQc+PGj1E3XSDRU5z0WI42UpskyS
sFKyTGCwWErMFmJgVXi5qyuvr7AgAACCCANa0WtaIIIFldlZlV4X52V1KXhx
Pvk3V8GLMtuwW0WC1rkCGmhVu52OyporjuQTq2aKnKPRjVUvfRseLKZjMZkz
CYyWMJmMKMSS/Wyu3du2wFqTK9WUrctStNlm1pN6ivZs72Hg138zMqatg2ua
p+pL0c3p9L3c8UENCg6LzBVYV48uX/ft2FV2qrmItBegW9SJJIEkhFJEkWMY
xjMP2qg696k3Up8yd3WKm7z66b6oM0xnTVBu11dr7f1d7Dqo137+DeIl44rh
NDPUtZIAOEgSgQCOw+wGACCAWvgqg5+PBwBproqa6tdM6Eo2qlTMzNVnuTEU
jk7VlvQQk7WtJEJuQAB1Iwl4xut8rPvehItTzzkimsMnglTmVOdOzKNlw6Nt
Vmug0YxrrqNECzvoAMEt8tOAHqvQJJAAghgiFEJ757I5lX1y0/WBENexDRfZ
5j1BFAkojknkOwLIFBh6RJEEwAESQ8cswCQTJs6OSRvPS6nbjIqosPPTZmZl
YwRJIAHBwEi5SYgkoImueGzWyizAqta0GaszdxZmcNxZMjt3E8gkuICxJlJd
nch2nmnqNQt7a3drWRrJhjZeuNFOw1CSGZiEiEiAph2mJDB11u2JGddXW7hG
lbuda5yugTW+c5iRDfXLXOJiAOMzfE1RiGCJy7im12Wbk0AQQBJJIAEEkgBa
uaWkgchEtApNJKqaiFBQq1ERCSSEOlCfUz3VyMWVFu+p2dqDO+O7tRSQQdjU
WNataZYAAVVnZmZlVzTENSC5AiqQS5csyoZT40oUJKklSKZeuAAPqJBIkgRK
SYj2gSSi71vMcP06CacLrIdtaKhrWw+jggEkKZ14ABl4iXcNEREJMzAkl1QA
Esl0AAjjhK6vOdumtZjvDxtpv4puB2qU7T/GiPhyw7DJmMyQyMis5XM9TKvW
uMwwl0yDIxmTMqW4eOt+9uytZa2mya2ratrdUQQkwIKFKjLOkkeWE+ZQhMZn
nJCnwZKaG8AuliRy5CSUMgySLEgMCHAF5HqcKxQAi9umzOiV2rTbRnHi4cNH
TXDND8E8XuM9407LCZ4anZTVOqd9iqqnq4tXXEy0Ia8VetFzmU7s1LYp09Wp
2rU3lrKGu95SqctNNXt40ZFB8D4+TqG3c1lYIidWPM471KyIi7p8tnZwpqn2
H2p1mjbd1Dzejdu3mBrOz9exJJIAAAAAA7lmZfF6H2edrvJMgBaa4AzIQvLR
+Okjdiup4/Wm883Bv6NwAsyuKmv75P56u7f08IVXc6LEMEWVNdOPLVB5Knhl
5VDSpojxkhqqrNZZvMy3mZlV7+ensAAysVLFx1X2fiLUNwn7e4KrReaTKKM9
N1WKHh3kvi8iMyzI98G8OtNBVY1v50TmTgJqiqwW0XRR8tTydOiO5wD+5cg+
ROKruVC1llTEMVNQfvVBrF19XPU73Rprw6FL/kf7U7fm1A2/j1u26NkcYm8o
vdlLu4E6SLgpbyLgwXCF1mlqTUprUrVgt/ByZSelOW4yLsh3/URwLNsDm9VH
BLr8VVaoyu2jkjlU398kOFUHLz1N3TIYpZsRbUekWzaSdaV8PV50Tl4twVXX
JDPBx5pdVo6+9y6dXZuqg5WU5vvzeC21Wt4u13RbpOYt5FkrsJgaRXV3InCX
JGS3pN8tKkNig6duVPDtxQdrjU5pdwkPBvRypXxC6gVXcpOvx0lXQnMLfshe
y9uvbb/532aTlVn/i7kinChIfMk52gA=

--8323329-1893821626-1392919404=:24360--
