Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841AbaIWWYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:24:34 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:35711 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaIWWYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:24:33 -0400
Date: Tue, 23 Sep 2014 15:24:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?B?5pyx6L6J?= <zhuhui@xiaomi.com>
cc: Weijie Yang <weijie.yang.kh@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "vinayakm.list@gmail.com" <vinayakm.list@gmail.com>,
        "weijie.yang@samsung.com" <weijie.yang@samsung.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "teawater@gmail.com" <teawater@gmail.com>
Subject: Re: [PATCH] Fix the issue that lowmemkiller fell into a cycle that
 try to kill a task
In-Reply-To: <C1476EAB93B413409890F290A20101879D8E9B@ex-mbox2>
Message-ID: <alpine.DEB.2.02.1409231523320.22630@chino.kir.corp.google.com>
References: <1411441029-8428-1-git-send-email-zhuhui@xiaomi.com> <20140923041738.GA6779@kroah.com> <C1476EAB93B413409890F290A20101879D8C96@ex-mbox2> <CAL1ERfMbcQGHBdiDw2yGw82_zUT5hBk+5uFHV=SPswUY-EtXVQ@mail.gmail.com>
 <C1476EAB93B413409890F290A20101879D8E9B@ex-mbox2>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-181491329-1411511071=:22630"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-181491329-1411511071=:22630
Content-Type: TEXT/PLAIN; charset=gb2312
Content-Transfer-Encoding: 8BIT

On Tue, 23 Sep 2014, Öì»Ô wrote:

> > By the way, whether we need to modify out_of_memory() which also
> > try to kill task?
> 
> I am not sure because LMK handle the memory issue early than OOM.
> But I think this issue will not affect OOM because OOM has oom_zonelist_trylock and oom_zonelist_unlock.
> 

The oom killer tries to schedule other processes that exit the oom killer 
without being a victim itself and any process that cannot get the zonelist 
lock will do the same in the page allocator.  The low memory killer case 
is somewhat different.
--531381512-181491329-1411511071=:22630--
