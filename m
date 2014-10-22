Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932084AbaJVQVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36988 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbaJVQVS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 12:21:18 -0400
Date: Wed, 22 Oct 2014 12:20:26 -0400
From: Don Zickus <dzickus@redhat.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: eranian@google.com, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, jolsa@redhat.com, jmario@redhat.com,
        rfowles@redhat.com
Subject: perf:  Translating mmap2 ids into socket info?
Message-ID: <20141022162026.GG135937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A question/request came up during our cache to cache analysis.  We were
wondering if give an unique mmap2 id (major, minor, inode, inode
generation), if it was possible to determine a cpu socket id that memory
was attached to at the time of the captured perf event?

We ran into a scenario awhile back where a dcache struct was allocated on
say node2 and then subsequently free'd.  The memory was thought to be
re-allocated on node0 for another dcache entry.  It turned out the memory
was still attached to node2 and was causing slowdowns.

Our cache-to-cache tool noticed the slowdown but we couldn't understand
why because we had falsely assumed the memory was allocated on the local
node but instead it was on the remote node.



I wasn't involved too much in this problem so the details provided above
are a little hazy.

Anyway, an idea popped up that having socket information might have helped
us solve/notice this problem sooner.

Thoughts?  Not sure if that data is possible.

Cheers,
Don


