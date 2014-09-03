Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620AbaICVVP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:21:15 -0400
Received: from mga14.intel.com ([192.55.52.115]:4514 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbaICVVM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:21:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,460,1406617200"; 
   d="scan'208";a="585868565"
Message-ID: <5407863B.9030608@intel.com>
Date: Wed, 03 Sep 2014 14:20:59 -0700
From: "H. Peter Anvin" <h.peter.anvin@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: RFC: Tainting the kernel on raw I/O access
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In a meeting earlier today, we discussed MSR access and that it could be
used to do bad things.  The same applies to other forms of raw I/O
(/dev/mem, /dev/port, ioperm, iopl, etc.)

This is basically the same problem with which the secure boot people
have been struggling.

Peter Z. suggested we should taint the kernel on raw I/O access, and I
tend to concur.

So what I would like to suggest is that we create a new kernel helper
function which can return an error in secure boot mode and otherwise
taints the kernel with a raw I/O taint.

What do people think?

	-hpa

