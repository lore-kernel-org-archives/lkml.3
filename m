Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaDRQdi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:33:38 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:31060 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbaDRQde (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:33:34 -0400
Message-ID: <1397838812.19331.3.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3] ipc,shm: disable shmmax and shmall by default
From: Davidlohr Bueso <davidlohr@hp.com>
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>, aswin@hp.com,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, linux-api@vger.kernel.org
Date: Fri, 18 Apr 2014 09:33:32 -0700
In-Reply-To: <5350EFAA.2030607@colorfullife.com>
References: <1397784345.2556.26.camel@buesod1.americas.hpqcorp.net>
	 <5350EFAA.2030607@colorfullife.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-18 at 11:26 +0200, Manfred Spraul wrote:
> Hi Davidlohr,
> 
> On 04/18/2014 03:25 AM, Davidlohr Bueso wrote:
> > So a value of 0 bytes or pages, for shmmax and shmall, respectively,
> > implies unlimited memory, as opposed to disabling sysv shared memory.
> That might be a second risk:
> Right now, a sysadmin can prevent sysv memory allocations with
> 
>      # sysctl kernel.shmall=0

Yeah, I had pointed this out previously, and it is addressed in the
changelog. shmall = 0 directly contradicts size < shmmin = 1, so I don't
know who's wrong there...

