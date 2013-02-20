Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964841Ab3BTPUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 10:20:37 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44995
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935589Ab3BTPUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 10:20:36 -0500
Message-ID: <1361373631.10155.40.camel@laptop>
Subject: Re: [patch v5 06/15] sched: log the cpu utilization at rq
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: torvalds@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, bp@alien8.de,
        pjt@google.com, namhyung@kernel.org, efault@gmx.de,
        vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, morten.rasmussen@arm.com
Date: Wed, 20 Feb 2013 16:20:31 +0100
In-Reply-To: <5124DED5.5050207@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
	  <1361164062-20111-7-git-send-email-alex.shi@intel.com>
	 <1361352643.10155.4.camel@laptop> <5124DED5.5050207@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 22:33 +0800, Alex Shi wrote:
> > There's generally a better value than 100 when using computers..
> seeing
> > how 100 is 64+32+4.
> 
> I didn't find a good example for this. and no idea of your suggestion,
> would you like to explain a bit more?

Basically what you're doing ends up being fixed point math, using 100 as
unit is inefficient, pick a power-of-2 and everything reduces to
bit-shifts.

http://en.wikipedia.org/wiki/Fixed-point_arithmetic

So use 128 or 1024 or whatever and you don't need mult and div
instructions to represent [0,1]

