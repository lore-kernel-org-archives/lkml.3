Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492AbaDBEI1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 00:08:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43915 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707AbaDBEI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 00:08:26 -0400
Message-ID: <533B8CE6.8090401@zytor.com>
Date: Tue, 01 Apr 2014 21:07:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>, Johannes Weiner <hannes@cmpxchg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org> <533B8C2D.9010108@linaro.org>
In-Reply-To: <533B8C2D.9010108@linaro.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 09:03 PM, John Stultz wrote:
> 
> So, maybe its best to ignore the fact that folks want to do semi-crazy
> user-space faulting via SIGBUS. At least to start with. Lets look at the
> semantic for the "normal" mark volatile, never touch the pages until you
> mark non-volatile - basically where accessing volatile pages is similar
> to a use-after-free bug.
> 
> So, for the most part, I'd say the proposed SIGBUS semantics don't
> complicate things for this basic use-case, at least when compared with
> things like zero-fill.  If an applications accidentally accessed a
> purged volatile page, I think SIGBUS is the right thing to do. They most
> likely immediately crash, but its better then them moving along with
> silent corruption because they're mucking with zero-filled pages.
> 
> So between zero-fill and SIGBUS, I think SIGBUS makes the most sense. If
> you have a third option you're thinking of, I'd of course be interested
> in hearing it.
> 

People already do SIGBUS for mmap, so there is nothing new here.

> Now... once you've chosen SIGBUS semantics, there will be folks who will
> try to exploit the fact that we get SIGBUS on purged page access (at
> least on the user-space side) and will try to access pages that are
> volatile until they are purged and try to then handle the SIGBUS to fix
> things up. Those folks exploiting that will have to be particularly
> careful not to pass volatile data to the kernel, and if they do they'll
> have to be smart enough to handle the EFAULT, etc. That's really all
> their problem, because they're being clever. :)

Yep.

	-hpa

