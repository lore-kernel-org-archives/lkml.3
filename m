Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbaGCPlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:41:37 -0400
Received: from www.sr71.net ([198.145.64.142]:52408 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753988AbaGCPlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:41:36 -0400
Message-ID: <53B579AD.1010201@sr71.net>
Date: Thu, 03 Jul 2014 08:41:33 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
CC: "\"Dr. David Alan Gilbert\"" <dgilbert@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, Keith Packard <keithp@keithp.com>,
        "Huangpeng (Peter)" <peter.huangpeng@huawei.com>,
        Isaku Yamahata <yamahata@valinux.co.jp>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        Wenchao Xia <wenchaoqemu@gmail.com>, Andrew Jones <drjones@redhat.com>,
        Juan Quintela <quintela@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 00/10] RFC: userfault
References: <1404319816-30229-1-git-send-email-aarcange@redhat.com>
In-Reply-To: <1404319816-30229-1-git-send-email-aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 09:50 AM, Andrea Arcangeli wrote:
> The MADV_USERFAULT feature should be generic enough that it can
> provide the userfaults to the Android volatile range feature too, on
> access of reclaimed volatile pages.

Maybe.

I certainly can't keep track of all the versions of the variations of
the volatile ranges patches.  But, I don't think it's a given that this
can be reused.  First of all, volatile ranges is trying to replace
ashmem and is going to require _some_ form of sharing.  This mechanism,
being tightly coupled to anonymous memory at the moment, is not a close
fit for that.

It's also important to call out that this is a VMA-based mechanism.  I
certainly can't predict what we'll merge for volatile ranges, but not
all of them are VMA-based.  We'd also need a mechanism on top of this to
differentiate plain not-present pages from not-present-because-purged pages.

That said, I _think_ this might fit well in to what the Mozilla guys
wanted out of volatile ranges.  I'm not confident about it, though.
