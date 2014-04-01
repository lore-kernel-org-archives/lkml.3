Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751525AbaDAU0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 16:26:36 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:13058 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaDAU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 16:26:35 -0400
Message-ID: <1396383989.25314.19.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: increase default size for shmmax
From: Davidlohr Bueso <davidlohr@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Manfred Spraul <manfred@colorfullife.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Gotou, Yasunori" <y-goto@jp.fujitsu.com>,
        chenhanxiao <chenhanxiao@cn.fujitsu.com>,
        Gao feng <gaofeng@cn.fujitsu.com>
Date: Tue, 01 Apr 2014 13:26:29 -0700
In-Reply-To: <CAHGf_=r03QWxw3Jg7BE3z37k4omgo_HRE9qCGw80ngtUD_iEeA@mail.gmail.com>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331143217.c6ff958e1fd9944d78507418@linux-foundation.org>
	 <1396306773.18499.22.camel@buesod1.americas.hpqcorp.net>
	 <20140331161308.6510381345cb9a1b419d5ec0@linux-foundation.org>
	 <1396308332.18499.25.camel@buesod1.americas.hpqcorp.net>
	 <20140331170546.3b3e72f0.akpm@linux-foundation.org>
	 <533A5CB1.1@jp.fujitsu.com>
	 <20140401121920.50d1dd96c2145acc81561b82@linux-foundation.org>
	 <CAHGf_=r03QWxw3Jg7BE3z37k4omgo_HRE9qCGw80ngtUD_iEeA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 16:15 -0400, KOSAKI Motohiro wrote:
> >> Our middleware engineers has been complaining about this sysctl limit.
> >> System administrator need to calculate required sysctl value by making sum
> >> of all planned middlewares, and middleware provider needs to write "please
> >> calculate systcl param by....." in their installation manuals.
> >
> > Why aren't people just setting the sysctl to a petabyte?  What problems
> > would that lead to?
> 
> I don't have much Fujitsu middleware knowledges. But I'd like to explain
> very funny bug I saw.
> 
> 1. middleware-A suggest to set SHMMAX to very large value (maybe
> LONG_MAX, but my memory was flushed)
> 2. middleware-B suggest to set SHMMAX to increase some dozen mega byte.
> 
> Finally, it was overflow and didn't work at all.
> 
> Let's demonstrate.
> 
> # echo 18446744073709551615 > /proc/sys/kernel/shmmax
> # cat /proc/sys/kernel/shmmax
> 18446744073709551615
> # echo 18446744073709551616 > /proc/sys/kernel/shmmax
> # cat /proc/sys/kernel/shmmax
> 0

hehe, what a nasty little tunable this is. Reminds me of this:
https://access.redhat.com/site/solutions/16333

