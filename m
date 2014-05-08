Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbaEHH2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:28:09 -0400
Received: from dedo.coelho.fi ([88.198.205.34]:43343 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751851AbaEHH2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:28:07 -0400
X-Greylist: delayed 1989 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 May 2014 03:28:07 EDT
Message-ID: <1399532071.12300.0.camel@dubbel>
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 08 May 2014 09:54:31 +0300
In-Reply-To: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 88.113.225.236
X-SA-Exim-Mail-From: luca@coelho.fi
Subject: Re: [PATCH] compiler.h: don't use temporary variable in
 __compiletime_assert()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on dedo)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-05-08 at 08:31 +0200, Johannes Berg wrote:
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
> ---

Tested-by: Luciano Coelho <luciano.coelho@intel.com>

