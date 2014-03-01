Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaCAAf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 19:35:59 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:44022 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaCAAf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 19:35:57 -0500
MIME-Version: 1.0
In-Reply-To: <1393625931-2858-1-git-send-email-quning@google.com>
References: <1393625931-2858-1-git-send-email-quning@google.com>
From: Ning Qu <quning@gmail.com>
Date: Fri, 28 Feb 2014 16:35:16 -0800
Message-ID: <CACQD4-5U3P+QiuNKzt5+VdDDi0ocphR+Jh81eHqG6_+KeaHyRw@mail.gmail.com>
Subject: Re: [PATCH 0/1] mm, shmem: map few pages around fault address if they
 are in page cache
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Hugh Dickins <hughd@google.com>
Cc: Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, Ning Qu <quning@gmail.com>,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ning Qu <quning@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry about my fault about the experiments, here is the real one.

Btw, apparently, there are still some questions about the results and
I will sync with Kirill about his test command line.

Below is just some simple experiment numbers from this patch, let me know if
you would like more:

Tested on Xeon machine with 64GiB of RAM, using the current default fault
order 4.

Sequential access 8GiB file
                        Baseline        with-patch
1 thread
    minor fault         8,389,052    4,456,530
    time, seconds    9.55            8.31

Random access 8GiB file
                        Baseline        with-patch
1 thread
    minor fault         8,389,315   6,423,386
    time, seconds    11.68         10.51



Best wishes,
-- 
Ning Qu
