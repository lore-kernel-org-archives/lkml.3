Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636AbaJKTcs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 15:32:48 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:56117 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaJKTcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 15:32:47 -0400
Message-ID: <1413055964.9362.50.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [bisected] e341694e3eb5 netlink_lookup() rcu conversion causes
 latencies
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sasha.levin@oracle.com>, paulmck@linux.vnet.ibm.com
Cc: Thomas Graf <tgraf@suug.ch>, Nikolay Aleksandrov <nikolay@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ursula Braun <braunu@de.ibm.com>
Date: Sat, 11 Oct 2014 12:32:44 -0700
In-Reply-To: <20141011083627.GB5074@osiris>
References: <20141011083627.GB5074@osiris>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-11 at 10:36 +0200, Heiko Carstens wrote:
> Hi all,
> 
> it just came to my attention that commit e341694e3eb5
> "netlink: Convert netlink_lookup() to use RCU protected hash table"
> causes network latencies for me on s390.
> 
> The testcase is quite simple and 100% reproducible on s390:
> 
> Simply login via ssh to a remote system which has the above mentioned
> patch applied. Any action like pressing return now has significant
> latencies. Or in other words, working via such a connection becomes
> a pain ;)
> 
> I haven't debugged it, however I assume the problem is that a) the
> commit introduces a synchronize_net() call und b) s390 kernels
> usually get compiled with CONFIG_HZ_100 while most other architectures
> use CONFIG_HZ_1000.
> If I change the kernel config to CONFIG_HZ_1000 the problem goes away,
> however I don't consider this a fix...
> 
> Another reason why this hasn't been observed on x86 may or may not be
> that we haven't implemented CONFIG_HAVE_CONTEXT_TRACKING on s390 (yet).
> But that's just guessing...

CC Paul and Sasha


