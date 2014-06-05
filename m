Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbaFELdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 07:33:45 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42379 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFELdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 07:33:44 -0400
Date: Thu, 05 Jun 2014 06:33:40 -0500
From: Felipe Contreras <felipe.contreras@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>
Message-ID: <53905594d284f_71f12992fc6a@nysa.notmuch>
Subject: Interactivity regression since v3.11 in mm/vmscan.c
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For a while I've noticed that my machine bogs down in certain
situations, usually while doing heavy I/O operations, it is not just the
I/O operations, but everything, including the graphical interface, even
the mouse pointer.

As far as I can recall this did not happen in the past.

I noticed this specially on certain operations, for example updating a
a game on Steam (to an exteranl USB 3.0 device), or copying TV episodes
to a USB memory stick (probably flash-based).

Today I decided to finally hunt down the problem, so I created a
synthetic test that basically consists on copying a bunch of files from
one drive to another (from an SSD to an external USB 3.0). This is
pretty similar to what I noticed; the graphical interface slows down.

Then I bisected the issue and it turns out that indeed it wasn't
happening in the past, it started happening in v3.11, and it was
triggered by this commit:

  e2be15f (mm: vmscan: stall page reclaim and writeback pages based on
  dirty/writepage pages encountered)

Then I went back to the latest stable version (v3.14.5), and commented
out the line I think is causing the slow down:

  if (nr_unqueued_dirty == nr_taken || nr_immediate)
	  congestion_wait(BLK_RW_ASYNC, HZ/10);

After that I don't notice the slow down any more.

Anybody has any ideas how to fix the issue properly?

-- 
Felipe Contreras
