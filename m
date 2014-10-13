Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbaJMIBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 04:01:45 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:55580 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752384AbaJMIBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 04:01:43 -0400
Message-ID: <1413187299.5232.44.camel@marge.simpson.net>
Subject: Re: [ANNOUNCE] BLD-3.17 release.
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 13 Oct 2014 10:01:39 +0200
In-Reply-To: <1413008458.5939.4.camel@localhost.localdomain>
References: <1413008458.5939.4.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 12:20 +0600, Rakib Mullick wrote: 
> BLD (The Barbershop Load Distribution Algorithm) patch for Linux 3.17

I had a curiosity attack, played with it a little.

My little Q6600 box could be describes as being "micro-numa", with two
pathetic little "nodes" connected by the worst interconnect this side of
tin cans and string.  Communicating tasks sorely missed sharing cache.

tbench
3.18.0-master
Throughput 287.411 MB/sec  1 clients  1 procs  max_latency=1.614 ms     1.000
Throughput 568.631 MB/sec  2 clients  2 procs  max_latency=1.942 ms     1.000
Throughput 1069.75 MB/sec  4 clients  4 procs  max_latency=18.494 ms    1.000
Throughput 1040.99 MB/sec  8 clients  8 procs  max_latency=17.364 ms    1.000

3.18.0-master-BLD                                                        vs master
Throughput 261.986 MB/sec  1 clients  1 procs  max_latency=11.943 ms     .911
Throughput 264.461 MB/sec  2 clients  2 procs  max_latency=11.884 ms     .465
Throughput 476.191 MB/sec  4 clients  4 procs  max_latency=11.497 ms     .445
Throughput 558.236 MB/sec  8 clients  8 procs  max_latency=9.008 ms      .536


TCP_RR 4 unbound clients
3.18.0-master
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       30.00    72436.65 
16384  87380  1        1       30.00    72438.55
16384  87380  1        1       30.00    72213.18
16384  87380  1        1       30.00    72493.48
                               sum     289581.86     1.000

3.18.0-master-BLD
TCP REQUEST/RESPONSE TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 127.0.0.1 (127.0.0.1) port 0 AF_INET
Local /Remote
Socket Size   Request  Resp.   Elapsed  Trans.
Send   Recv   Size     Size    Time     Rate         
bytes  Bytes  bytes    bytes   secs.    per sec   

16384  87380  1        1       30.00    29014.09
16384  87380  1        1       30.00    28804.53
16384  87380  1        1       30.00    28999.40
16384  87380  1        1       30.00    28901.84
                               sum     115719.86      .399 vs master


