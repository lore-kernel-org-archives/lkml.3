Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161547Ab3DELC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 07:02:28 -0400
Received: from a2s31.a2hosting.com ([216.119.140.66]:38885 "EHLO
	a2s31.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3DELC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 07:02:27 -0400
X-Greylist: delayed 4147 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Apr 2013 07:02:27 EDT
Message-ID: <515E9F0C.1000204@biovista.com>
Date: Fri, 05 Apr 2013 12:53:16 +0300
From: Vassilis Virvilis <v.virvilis@biovista.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Debugging COW (copy on write) memory after fork: Is it possible to
 dump only the private anonymous memory of a process?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s31.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - biovista.com
X-Get-Message-Sender-Via: a2s31.a2hosting.com: authenticated_id: v.virvilis@biovista.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, sorry if this is off topic. Just point me to the right direction. 
Please cc me also in the reply.

Question
--------

Is it possible to dump only the private anonymous memory of a process?

Background
----------

I have a process where it reads and it initializes a large portion of 
the memory (around 2.3GB). This memory is effectively read only from 
that point and on. After the initialization I fork the process to 
several children in order to take advantage of the multicore 
architecture of modern cpus. The problem is that finally the program 
ends up requiring number_of_process * 2.3GB memory effectively entering 
swap thrashing and destroying the performance.

Steps so far
------------

The first thing I did is to monitor the memory. I found about 
/proc/$pid/smaps and the http://wingolog.org/pub/mem_usage.py.

What happens is the following

     The program starts reads from disk and has 2.3GB of private mappings
     The program forks. Immediately the 2.3GB become shared mapping 
between the parent and the child. Excellent so far.
     As the time goes and the child starts performing its tasks the 
shared memory is slowly migrating to the private mappings of each 
process effectively blowing up the memory requirements.

I thought that if I could see (dump) the private mappings of each 
process I could see from the data why the shared mappings are being 
touched so I tried to dump the core with gcore and by playing with 
/proc/$pid/coredump_filter like this

echo 0x1 > /proc/$pid/coredump_filter
gcore $pid

Unfortunately it always dumps 2.3GB despite the setting in 
/proc/$pid/coredump_filter which says private anonymous mappings.

I have researched the question in google.

I even posted it in stack overflow.

Any other ideas?

Thanks in advance

	Vassilis Virvilis

