Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaLJOX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 09:23:29 -0500
Received: from mx0.aculab.com ([213.249.233.131]:54887 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756786AbaLJOX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 09:23:27 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Jesper Dangaard Brouer'" <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Christoph Lameter <cl@linux.com>
CC: "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@plumgrid.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: RE: [RFC PATCH 0/3] Faster than SLAB caching of SKBs with qmempool
	(backed by alf_queue)
Thread-Topic: [RFC PATCH 0/3] Faster than SLAB caching of SKBs with qmempool
	(backed by alf_queue)
Thread-Index: AQHQFIO0Ikj80L4t4UGcEvv4vfI+lpyI3+Ug
Date: Wed, 10 Dec 2014 14:22:22 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D1CA0A193@AcuExch.aculab.com>
References: <20141210033902.2114.68658.stgit@ahduyck-vm-fedora20>
 <20141210141332.31779.56391.stgit@dragon>
In-Reply-To: <20141210141332.31779.56391.stgit@dragon>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id sBAENatn006541

From: Jesper Dangaard Brouer
> The network stack have some use-cases that puts some extreme demands
> on the memory allocator.  One use-case, 10Gbit/s wirespeed at smallest
> packet size[1], requires handling a packet every 67.2 ns (nanosec).
> 
> Micro benchmarking[2] the SLUB allocator (with skb size 256bytes
> elements), show "fast-path" instant reuse only costs 19 ns, but a
> closer to network usage pattern show the cost rise to 45 ns.
> 
> This patchset introduce a quick mempool (qmempool), which when used
> in-front of the SKB (sk_buff) kmem_cache, saves 12 ns on "fast-path"
> drop in iptables "raw" table, but more importantly saves 40 ns with
> IP-forwarding, which were hitting the slower SLUB use-case.
> 
> 
> One of the building blocks for achieving this speedup is a cmpxchg
> based Lock-Free queue that supports bulking, named alf_queue for
> Array-based Lock-Free queue.  By bulking elements (pointers) from the
> queue, the cost of the cmpxchg (approx 8 ns) is amortized over several
> elements.

It seems to me that these improvements could be added to the
underlying allocator itself.
Nesting allocators doesn't really seem right to me.

	David

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
