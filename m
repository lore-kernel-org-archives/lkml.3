Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbaGGWaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 18:30:05 -0400
Received: from one.firstfloor.org ([193.170.194.197]:32962 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656AbaGGWaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 18:30:04 -0400
Date: Tue, 8 Jul 2014 00:30:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: fallout of 16K stacks
Message-ID: <20140707223001.GD18735@two.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since the 16K stack change I noticed a number of problems with
my usual stress tests. They have a tendency to bomb out
because something cannot fork.

- AIM7 on a dual socket socket system now cannot reliably run 
>1000 parallel jobs.
- LTP stress + memhog stress in parallel to something else
usually doesn't survive the night.

Do we need to strengthen the memory allocator to try
harder for 16K?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
