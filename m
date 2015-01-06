Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754962AbbAFLei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:34:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:37042 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbAFLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:34:37 -0500
Date: Tue, 6 Jan 2015 12:34:20 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH] mutex: Always clear owner field upon mutex_unlock()
Message-ID: <20150106113420.GR29390@twins.programming.kicks-ass.net>
References: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 10:29:35AM +0000, Chris Wilson wrote:
> Currently if DEBUG_MUTEXES is enabled, the mutex->owner field is only
> cleared iff debug_locks is active. This exposes a race to other users of
> the field where the mutex->owner may be still set to a stale value,
> potentially upsetting mutex_spin_on_owner() among others.


Thanks
