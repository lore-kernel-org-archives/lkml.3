Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbaGWEzK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 00:55:10 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:47734 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbaGWEzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 00:55:07 -0400
Message-ID: <1406091303.5076.33.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/5] futex: introduce an optimistic spinning futex
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@linux.intel.com>,
        Davidlohr Bueso <davidlohr@hp.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-doc@vger.kernel.org, Jason Low <jason.low2@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Date: Wed, 23 Jul 2014 06:55:03 +0200
In-Reply-To: <8761iq3bp3.fsf@tassilo.jf.intel.com>
References: <1405956271-34339-1-git-send-email-Waiman.Long@hp.com>
	 <8761iq3bp3.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 09:42 -0700, Andi Kleen wrote:

> FWIW the main problem is currently that switch-through-idle is so 
> slow. I think improving that would give a boost to far more
> situations.

Two high frequency idle enter/exit suckage spots:

1) nohz (tick) - it's expensive to start/stop tick on every micro-idle,
throttle it or something.

2) ondemand governor - tweak silly default settings to reflect the
reality that we routinely schedule communicating threads cross core.

(3. seek/destroy fastpath cycles, damn things multiply over time)

-Mike

