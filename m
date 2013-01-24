Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab3AXGvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 01:51:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:53683 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab3AXGvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 01:51:16 -0500
Message-ID: <1359010272.5833.39.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Thu, 24 Jan 2013 07:51:12 +0100
In-Reply-To: <5100CE1F.7080704@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358865692.5782.420.camel@marge.simpson.net>
	 <50FF4EA0.1070000@linux.vnet.ibm.com>
	 <1358915494.5752.46.camel@marge.simpson.net>
	 <50FF7086.4020509@linux.vnet.ibm.com>
	 <1358922520.5752.91.camel@marge.simpson.net>
	 <50FF8CD8.4060105@linux.vnet.ibm.com>
	 <1358929257.5752.109.camel@marge.simp! son.net>
	 <50FF9F92.60202@linux.vnet.ibm.com>
	 <1358930968.5752.123.camel@marge.simpson.net>
	 <50FFA695.6010407@linux.vnet.ibm.com>
	 <1358932694.5752.126.camel@marge.simpson.net>
	 <1358933555.5752.132.camel@marge.simpson.net>
	 <5100CE1F.7080704@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:f3P9MSyyM0Sx1aL8JJbZt6Q9wXpm4/PaOFQoZQk/nMG
 s+ynK+J/IYKuX/9s92UHUVDTGRW3A84Zu/DMsvipxqpt78F7nI
 R8H9P06N+aI7p0ZmUnx1fmISltiEVl6h0z5qgc7fwKW//2+3DB
 svDcSMAVUeKZ+URvAXI5UpruZZoefPm3HWzwAbdev3E1RtUl+f
 XA9AGUuWMV9W17MwaIBEr/GWa33M+im0Ze4eClWanGGezlqJWZ
 VzXyOw8qwVbjD5nhxBhzHbDigRfBPA98FcbwukdPA2KIHwhhp8
 NtTark/G9JVQJ5drKHQ0KGeaRzctk/IKgq6ewMojkJFzhheHO8
 DvGwIXfbKig9eGsKN5LOBKsFT/SncdE+fdhO0skK+SQnp/dm92
 hKXykMO3wHt1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 14:01 +0800, Michael Wang wrote:

> I've enabled WAKE flag on my box like you did, but still can't see
> regression, and I've just tested on a power server with 64 cpu, also
> failed to reproduce the issue (not compared with virgin yet, but can't
> see collapse).

I'm not surprised.  I'm seeing enough inconsistent crap to come to the
conclusion that stock scheduler knobs flat can't be used on a largish
box, they're just too preempt-happy, leading to weird crap.

My 2 missing nodes came back, and the very same kernel that highly
repeatably collapsed with 2 nodes does not with 4 nodes, and 2 nodes
does not collapse with only preemption knob tweaking, and that's
bullshit.  Virgin shows instability in the mid-range, make a tiny tweak
that should have little if any effect there, and that instability
vanishes entirely.  Test runs are not consistent enough boot to boot etc
etc.  Either stock knobs suck on NUMA boxen, or this box is possessed.

-Mike

