Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623AbaDBXsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 19:48:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:43833 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312AbaDBXsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 19:48:21 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.8.4
Message-ID: <533CA179.3050005@jp.fujitsu.com>
Date: Thu, 03 Apr 2014 08:47:05 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        chenhanxiao <chenhanxiao@cn.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>	<20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>	<1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>	<20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>	<1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>	<20140331170546.3b3e72f0.akpm@linux-foundation.org>	<533A5CB1.1@jp.fujitsu.com>	<20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org> <20140402155507.1d976144@alan.etchedpixels.co.uk>
In-Reply-To: <20140402155507.1d976144@alan.etchedpixels.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/04/02 23:55), One Thousand Gnomes wrote:
>> Why aren't people just setting the sysctl to a petabyte?  What problems
>> would that lead to?
>
> Historically - hanging on real world desktop systems when someone
> accidentally creates a giant SHM segment and maps it.
>
> If you are running with vm overcmmit set to actually do checks then it
> *shouldn't* blow up nowdays.
>
> More to the point wtf are people still using prehistoric sys5 IPC APIs
> not shmemfs/posix shmem ?
>

AFAIK, there are many sys5 ipc users.
And admins are using ipcs etc...for checking status. I guess they will not
change the attitude until they see trouble with sysv IPC.
*) I think some RedHat's document(MRG?) says sysv IPC is obsolete clearly but...

I tend to recommend posix shared memory when people newly starts development but
there is an another trap.
IIUC, for posix shmem, an implicit size limit is applied by tmpfs's fs size.
tmpfs mounted on /dev/shm tends to be limited to half size of system memory.
It's hard to know that limit for users before hitting trouble.

Thanks,
-Kame

