Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbaDBRk2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 13:40:28 -0400
Received: from www.sr71.net ([198.145.64.142]:56510 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932666AbaDBRkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 13:40:17 -0400
Message-ID: <533C4B7E.6030807@sr71.net>
Date: Wed, 02 Apr 2014 10:40:14 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org> <533B8C2D.9010108@linaro.org> <20140402163013.GP14688@cmpxchg.org> <533C3BB4.8020904@zytor.com> <533C3CDD.9090400@zytor.com> <20140402171812.GR14688@cmpxchg.org>
In-Reply-To: <20140402171812.GR14688@cmpxchg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 10:18 AM, Johannes Weiner wrote:
> Hence my follow-up question in the other mail about how large we
> expect such code caches to become in practice in relationship to
> overall system memory.  Are code caches interesting reclaim candidates
> to begin with?  Are they big enough to make the machine thrash/swap
> otherwise?

A big chunk of the use cases here are for swapless systems anyway, so
this is the *only* way for them to reclaim anonymous memory.  Their
choices are either to be constantly throwing away and rebuilding these
objects, or to leave them in memory effectively pinned.

In practice I did see ashmem (the Android thing that we're trying to
replace) get used a lot by the Android web browser when I was playing
with it.  John said that it got used for storing decompressed copies of
images.
