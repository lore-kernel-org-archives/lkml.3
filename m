Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaEHG4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 02:56:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:42011 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbaEHG4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 02:56:50 -0400
Date: Thu, 8 May 2014 08:56:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in
 __compiletime_assert()
Message-ID: <20140508065646.GF2844@laptop.programming.kicks-ass.net>
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 08:31:25AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Usually, BUG_ON and friends aren't even evaluated in sparse, but
> recently compiletime_assert_atomic_type() was added, and that now
> results in a sparse warning every time it is used.
> 
> The reason turns out to be the temporary variable, after it sparse
> no longer considers the value to be a constant, and results in a
> warning and an error. The error is the more annoying part of this
> as it suppresses any further warnings in the same file, hiding
> other problems.
> 
> Since this is all about compile time and the condition should be
> side-effect free to start with, there's no downside (apart maybe
> from a slight compilation time penalty?) to just duplicating it,
> leaving sparse able to evaluate it at check time, getting rid of
> the warning and error.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Peter Zijlstra <peterz@infradead.org>
