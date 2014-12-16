Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531AbaLPAO4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 19:14:56 -0500
Received: from ns.horizon.com ([71.41.210.147]:41170 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750818AbaLPAOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 19:14:55 -0500
Date: 15 Dec 2014 19:14:53 -0500
Message-ID: <20141216001453.1808.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, sfr@canb.auug.org.au
Subject: Re: [PATCH v2] VERIFY_OCTAL_PERMISSIONS: Move to <linux/sysfs.h> where it belongs
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rdunlap@infradead.org, rusty@rustcorp.com.au
In-Reply-To: <20141216100957.6f42e898@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Please do *not* mix changes up like this.  Split this out into a
> separate patch, please (1 logical change per patch).

Um... I thought I was doing that.  More particularly, the task of
untangling header file dependencies eseemed sufficiently cohesive
that it could be considered one logical change.

It was one round of thinking and analysis about what declarations the
affected files depend on.

Although syntactically possible, given the small size of the change (I
deleted a total of 5 #includes, 2 from moduleparam.h and 3 from sysfs.h),
it didn't seem worth breaking it up further.

> And testing only
> on x86_64 is not "sure" when talking about header file pruning (but at
> least you did the "all" configs).

Well, the first round was reading and understanding the headers; the
compile was just to make sure.

The files I was messing with (moduleparam.h and sysfs.h) don't have a
lot of architecture-specificness within them.  The main danger is that
they're used in a zillion places and some caller might depend on the
over-inclusion.

I was rushing to get that to Andrew while the coversation was ongoing
(if you check the mail headers, only a few minutes separated the various
messages) so I was less cautious than usual, but given that a mistake
would result in a nice obvious compile error (with an almost as obvious
fix), it seemed worth the risk.

If my haste made me judge wrong, I apologize.  Was I very wrong, or just
a bit over the line?
