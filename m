Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422768Ab3CVRvO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:51:14 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:13800 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422678Ab3CVRvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:51:13 -0400
Message-ID: <1363974671.1946.4.camel@buesod1.americas.hpqcorp.net>
Subject: Re: ipc,sem: sysv semaphore scalability
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com
Date: Fri, 22 Mar 2013 10:51:11 -0700
In-Reply-To: <1363809337-29718-1-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:55 -0400, Rik van Riel wrote:
> Include lkml in the CC: this time... *sigh*
> ---8<---
> 
> This series makes the sysv semaphore code more scalable,
> by reducing the time the semaphore lock is held, and making
> the locking more scalable for semaphore arrays with multiple
> semaphores.
> 
> The first four patches were written by Davidlohr Buesso, and
> reduce the hold time of the semaphore lock.
> 
> The last three patches change the sysv semaphore code locking
> to be more fine grained, providing a performance boost when
> multiple semaphores in a semaphore array are being manipulated
> simultaneously.
> 
> On a 24 CPU system, performance numbers with the semop-multi
> test with N threads and N semaphores, look like this:
> 
> 	vanilla		Davidlohr's	Davidlohr's +	Davidlohr's +
> threads			patches		rwlock patches	v3 patches
> 10	610652		726325		1783589		2142206
> 20	341570		365699		1520453		1977878
> 30	288102		307037		1498167		2037995
> 40	290714		305955		1612665		2256484
> 50	288620		312890		1733453		2650292
> 60	289987		306043		1649360		2388008
> 70	291298		306347		1723167		2717486
> 80	290948		305662		1729545		2763582
> 90	290996		306680		1736021		2757524
> 100	292243		306700		1773700		3059159
> 

Some results with semop-multi on my 4 core laptop:

	vanilla		v3 patchset
threads
10       5094473         10289146
20       5079946         10187923
30       5041258         10660635
40       4942786         10876009
50       5076437         10759434
60       5139024         10797032
70       5103811         10698323
80       5094850          9959675
90       5085774         10054844
100      4939547          9798291




