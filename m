Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753029AbaAXWaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:30:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45344 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752290AbaAXWaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:30:05 -0500
Date: Fri, 24 Jan 2014 14:30:03 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] mm: reduce reclaim stalls with heavy anon and dirty
 cache
Message-Id: <20140124143003.2629e9c2c8c2595e805c8c25@linux-foundation.org>
In-Reply-To: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org>
References: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jan 2014 17:03:02 -0500 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Tejun reported stuttering and latency spikes on a system where random
> tasks would enter direct reclaim and get stuck on dirty pages.  Around
> 50% of memory was occupied by tmpfs backed by an SSD, and another disk
> (rotating) was reading and writing at max speed to shrink a partition.

Do you think this is serious enough to squeeze these into 3.14?
