Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab3HaGoc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 02:44:32 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:56282 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab3HaGob (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 02:44:31 -0400
Date: Sat, 31 Aug 2013 06:44:30 +0000
From: Eric Wong <normalperson@yhbt.net>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: ipv4: warnings on sk_wmem_queued
Message-ID: <20130831064430.GA9903@dcvr.yhbt.net>
References: <20130830195638.GA27393@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130830195638.GA27393@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> I noticed these warnings on stock 3.10.9 running stress tests on
> cmogstored.git (git://bogomips.org/cmogstored.git) doing standard
> HTTP server stuff between lo and tmpfs:

I'm still running the same test (in-place upgraded cmogstored a few
times to fix some bugs), and haven't hit these warnings again
(constantly pushing around 20GB/s total).

I forget to mention cmogstored is multithreaded and idle clients
automatically migrate between threads when becoming active (using
EPOLLONESHOT), so maybe this tickles some rare race condition
somewhere...

> Aug 30 06:03:54 localhost kernel: WARNING: at net/core/stream.c:200 sk_stream_kill_queues+0x131/0x140()
<snip>
> Aug 30 06:03:54 localhost kernel: WARNING: at net/ipv4/af_inet.c:155 inet_sock_destruct+0x191/0x1e0()

I probably won't be in a good position to reboot/test patches until
Tuesday, though.
