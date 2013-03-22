Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395Ab3CVBOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 21:14:55 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44978 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab3CVBOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 21:14:54 -0400
Message-ID: <1363914891.31240.62.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 7/7] ipc,sem: fine grained locking for semtimedop
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@surriel.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, hhuang@redhat.com, jason.low2@hp.com,
        walken@google.com, lwoodman@redhat.com, chegu_vinod@hp.com,
        Rik van Riel <riel@redhat.com>
Date: Thu, 21 Mar 2013 18:14:51 -0700
In-Reply-To: <1363809337-29718-8-git-send-email-riel@surriel.com>
References: <1363809337-29718-1-git-send-email-riel@surriel.com>
	 <1363809337-29718-8-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-20 at 15:55 -0400, Rik van Riel wrote:
> Introduce finer grained locking for semtimedop, to handle the
> common case of a program wanting to manipulate one semaphore
> from an array with multiple semaphores.
> 
> If the call is a semop manipulating just one semaphore in
> an array with multiple semaphores, only take the lock for
> that semaphore itself.
> 
> If the call needs to manipulate multiple semaphores, or
> another caller is in a transaction that manipulates multiple
> semaphores, the sem_array lock is taken, as well as all the
> locks for the individual semaphores.
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
> Signed-off-by: Rik van Riel <riel@redhat.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>

Acked-by: Davidlohr Bueso <davidlohr.bueso@hp.com>

