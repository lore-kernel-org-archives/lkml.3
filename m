Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376Ab3CLKJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 06:09:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44096
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754962Ab3CLKJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 06:09:07 -0400
Message-ID: <1363082932.14933.19.camel@laptop>
Subject: Re: [PATCH] sched: wakeup buddy
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 12 Mar 2013 11:08:52 +0100
In-Reply-To: <513E9FC6.4060507@linux.vnet.ibm.com>
References: <5136EB06.2050905@linux.vnet.ibm.com>
	 <1362677252.10972.26.camel@laptop> <5139520C.1060109@linux.vnet.ibm.com>
	 <1362998219.14933.9.camel@laptop> <513E9FC6.4060507@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does something simple like a per-task throttle of wake_affine() gain
similar benefits? Say something like only do wake_affine() once every
10 ms or so (counting on the wakee, not waker).

The rationale being that wake_affine() relies on load-balance
statistics that aren't updated that much faster, so calling it more
often than that seems pointless.

Something like that should take a lot less lines to implement.

Just wondering..

