Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968207Ab3E3LIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 07:08:45 -0400
Received: from canardo.mork.no ([148.122.252.1]:55335 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968169Ab3E3LIh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 07:08:37 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: skbuff: use _RET_IP_
Organization: m
References: <1369861743.4188.33.camel@buesod1.americas.hpqcorp.net>
	<51A6768B.5050603@cogentembedded.com>
Date: Thu, 30 May 2013 13:08:10 +0200
In-Reply-To: <51A6768B.5050603@cogentembedded.com> (Sergei Shtylyov's message
	of "Thu, 30 May 2013 01:43:39 +0400")
Message-ID: <87obbsohd1.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> writes:

>     Why not "text:%#lx" as already used in this string? It's
> equivalent to "0x%lx".

Well, I don't know the reasoning in this case, but I'd like to note that
those are not strictly equivalent.  Personally I find the formatting of 0
annoying enough to avoid %#x for any value which may be 0.  It's
especially bad if you try to line up things by adding leading zeros.

I would expect these to produce the same result, but they don't:

	printf("0x%02hhx\n", 0);
	printf("%#04hhx\n", 0);

Ending up with a 4 digit output when you expect 2 is very confusing.  It
doesn't matter that 0 is 0 in any case.  Why doesn't the same happen to
1 then?  This is just inconsistent behaviour, and I see no valid excuse
for it.

IMHO the single format character saved isn't worth this at all.  I'll
continue using 0x%x


Bjørn
