Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818Ab3KVV2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 16:28:06 -0500
Received: from relay2.sgi.com ([192.48.179.30]:53926 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755248Ab3KVV2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 16:28:01 -0500
Date: Fri, 22 Nov 2013 15:28:07 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: BUG: mm, numa: test segfaults, only when NUMA balancing is on
Message-ID: <20131122212807.GR3062@sgi.com>
References: <20131016155429.GP25735@sgi.com>
 <20131104145828.GA1218@suse.de>
 <20131104200346.GA3066@sgi.com>
 <20131106131048.GC4877@suse.de>
 <20131107214838.GY3066@sgi.com>
 <20131108112054.GB5040@suse.de>
 <20131108221329.GD4236@sgi.com>
 <20131112212902.GA4725@sgi.com>
 <20131115000901.GB26002@suse.de>
 <20131115144504.GE26002@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115144504.GE26002@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If the warning added by that patch does *not* trigger than can you also
> test this patch? It removes the barriers which should not be necessary
> and takes a reference tot he page before waiting on the lock. The
> previous version did not take the reference because otherwise the
> WARN_ON could not distinguish between a migration waiter and a surprise
> gup.

Sorry for the delay; been a bit busy.  I tested both of these patches on
top of this one (separately, of course):

http://www.spinics.net/lists/linux-mm/msg63919.html

I think that's the one you were referring to, if not send me a pointer
to the correct one and I'll give it another shot.  Both patches still
segfaulted, so it doesn't appear that either of these solved the
problem.  If you have anything else you'd like for me to try let me
know.

- Alex
