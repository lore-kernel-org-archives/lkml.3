Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432AbaDMDAc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 23:00:32 -0400
Received: from mga01.intel.com ([192.55.52.88]:54099 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751359AbaDMDAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 23:00:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,849,1389772800"; 
   d="scan'208";a="512115199"
From: Andi Kleen <andi@firstfloor.org>
To: Alexander.Kleinsorge@gmx.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: new module to check constant memory for corruption
References: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
Date: Sat, 12 Apr 2014 20:00:30 -0700
In-Reply-To: <trinity-aef9715a-72d2-4824-a3d8-306d5850c633-1397352790457@3capp-gmx-bs18>
	(Alexander Kleinsorge's message of "Sun, 13 Apr 2014 03:33:10 +0200")
Message-ID: <87eh12hr1t.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander.Kleinsorge@gmx.de writes:

> ramcheck kernel module
> new module to check constant memory for corruption
>
> detect corruption of constant kernel memory (text and data) periodically.
> runtime costs about 1..2 ms per sec (about 10 mb with 5 mb/ms),
> which is distributed over 8 (BLOCKS) time partitions (less than half
> ms per sec).
> in case of checksum (xor) error, an kernel log is posted.
> manual trigger via /proc/ramcheck is possible.
> range: kallsyms_lookup_name("_text") .. kallsyms_lookup_name("__end_rodata")


Can you explain how this works? How does it handle legal writes?

If it just checks its own memory it could be done in user space.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
