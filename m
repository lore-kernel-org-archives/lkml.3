Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933633Ab3GDH71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 03:59:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33778 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755295Ab3GDH70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 03:59:26 -0400
Date: Thu, 4 Jul 2013 09:58:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alex Shi <alex.shi@intel.com>
Cc: tglx@linutronix.de, hpa@linux.intel.com, tim.c.chen@linux.intel.com,
        linux-kernel@vger.kernel.org, andi.kleen@intel.com, mingo@elte.hu
Subject: Re: [URGENT rfc patch 0/3] tsc clocksource bug fix
Message-ID: <20130704075840.GH18898@dyad.programming.kicks-ass.net>
References: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372916056-24301-1-git-send-email-alex.shi@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 01:34:13PM +0800, Alex Shi wrote:

> If the tsc is marked as constant and nonstop, could we set it as system
> clocksource when do tsc register? w/o checking it on clocksource_watchdog?

I'd not do that; the BIOS can still screw you over, we need some validation.

That said; we do need means to disable the clocksource watchdog -- although I
suppose Frederic might already have provided this for this NOHZ efforts when I
wasn't looking.
