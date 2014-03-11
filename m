Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaCKJw1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:52:27 -0400
Received: from mx0.aculab.com ([213.249.233.131]:43144 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751688AbaCKJwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:52:24 -0400
From: David Laight <David.Laight@ACULAB.COM>
To: "'David Miller'" <davem@davemloft.net>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
CC: "ast@plumgrid.com" <ast@plumgrid.com>,
        "dborkman@redhat.com" <dborkman@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "wad@chromium.org" <wad@chromium.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "hpa@zytor.com" <hpa@zytor.com>, "hagen@jauu.net" <hagen@jauu.net>,
        "jesse@nicira.com" <jesse@nicira.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "edumazet@google.com" <edumazet@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "acme@infradead.org" <acme@infradead.org>,
        "penberg@iki.fi" <penberg@iki.fi>,
        "arjan@infradead.org" <arjan@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter
 and converter
Thread-Topic: [PATCH v8 net-next 1/3] filter: add Extended BPF interpreter
 and converter
Thread-Index: AQHPPNIlPzf9J2AI8kK85+37ov6sw5rboZgQ
Date: Tue, 11 Mar 2014 09:51:32 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D0F6DA53F@AcuExch.aculab.com>
References: <1394431444-6987-2-git-send-email-ast@plumgrid.com>
	<20140310.215104.2095195123238829635.davem@davemloft.net>
	<CA+55aFx7rdm9DGOTTgAKTHNkdfrvQYhT9PRs5MhUPr1gQzWEgA@mail.gmail.com>
 <20140310.222449.561233409099006984.davem@davemloft.net>
In-Reply-To: <20140310.222449.561233409099006984.davem@davemloft.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Mon, 10 Mar 2014 19:02:18 -0700
> 
> > I would generally suggest that people only use "bool" for function
> > return types, and absolutely nothing else. Seriously.
> 
> I think it makes sense for function arguments too.

'bool' doesn't necessarily even make sense for function arguments
and results.
It might require the same additional masking of high bits that
are required for 'short' and 'char' parameters.

Also, IIRC, one of the arm ABIs used 32bit 'bool'.

Even the extra code that gets added to ensure that the 'bool'
values are either 0 or 1 can be a problem.
I don't know whether the recent compilers (or standards) say
whether the reader or writer is expected to enforce the domain.
But if the compiler uses a bit-wise AND for bool_a & bool_b there
is definitely scope for unexpected behaviour, and if the compiler
does anything else you get unwanted instructions and possibly branches.
Some old versions of gcc made a 'pigs breakfast' of bool_a |= bool_b.

	David



