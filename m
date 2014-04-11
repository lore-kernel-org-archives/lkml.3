Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaDKUsM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 16:48:12 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:10208 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaDKUsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 16:48:11 -0400
Message-ID: <1397249287.2503.24.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] ipc,shm: disable shmmax and shmall by default
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Greg Thelen <gthelen@google.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 11 Apr 2014 13:48:07 -0700
In-Reply-To: <1397248035.2503.20.camel@buesod1.americas.hpqcorp.net>
References: <1396235199.2507.2.camel@buesod1.americas.hpqcorp.net>
	 <20140331170546.3b3e72f0.akpm@linux-foundation.org>
	 <1396371699.25314.11.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=qsf6vN5k=-PLraG8Q_uU1pofoBDktjVH1N92o76xPadQ@mail.gmail.com>
	 <1396377083.25314.17.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rLLBDr5ptLMvFD-M+TPQSnK3EP=7R+27K8or84rY-KLA@mail.gmail.com>
	 <1396386062.25314.24.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rhXrBQSmDBJJ-vPxBbhjJ91Fh2iWe1cf_UQd-tCfpb2w@mail.gmail.com>
	 <20140401142947.927642a408d84df27d581e36@linux-foundation.org>
	 <CAHGf_=p70rLOYwP2OgtK+2b+41=GwMA9R=rZYBqRr1w_O5UnKA@mail.gmail.com>
	 <20140401144801.603c288674ab8f417b42a043@linux-foundation.org>
	 <CAHGf_=r5AUu6yvJgOzwYDghBo6iT2q+nNumpvqwer+igcfChrA@mail.gmail.com>
	 <1396394931.25314.34.camel@buesod1.americas.hpqcorp.net>
	 <CAHGf_=rH+vfFzRrh35TETxjFU2HM0xnDQFweQ+Bfw20Pm2nL3g@mail.gmail.com>
	 <1396484447.2953.1.camel@buesod1.americas.hpqcorp.net>
	 <5348343F.6030300@colorfullife.com>
	 <1397248035.2503.20.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-11 at 13:27 -0700, Davidlohr Bueso wrote:
> On Fri, 2014-04-11 at 20:28 +0200, Manfred Spraul wrote:
> > Your patch disables checking shmmax, shmall *AND* checking for SHMMIN.
> 
> Right, if shmmax is 0, then there's no point checking for shmmin,
> otherwise we'd always end up returning EINVAL.

Actually that's complete bogus.

Now that I think of it, shmget(key, 0, flg) should still return EINVAL.
That has *nothing* to do with any limits we are changing here and is
simply wrong since the passed size still cannot be less than 1 (shmmin).
I'll update the patch, thanks for pointing this out.

