Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab3EaLew (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:34:52 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:41578 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab3EaLep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:34:45 -0400
Date: Fri, 31 May 2013 13:34:41 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Yuanhan Liu <yuanhan.liu@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86: Fix adjust_range_size_mask calling position
Message-ID: <20130531113441.GB7131@gmail.com>
References: <CAE9FiQXr4S0P5P5JdegRyozSX4OCJ6+6MMybmAaMPCzfqe6yWg@mail.gmail.com>
 <1369861769-30687-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369861769-30687-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Commit 8d57470d cause a kernel panic while setting mem=2G.
>      [mem 0x00000000-0x000fffff] page 4k
>      [mem 0x7fe00000-0x7fffffff] page 1G
>      [mem 0x7c000000-0x7fdfffff] page 1G
>      [mem 0x00100000-0x001fffff] page 4k
>      [mem 0x00200000-0x7bffffff] page 2M
> 
> for last entry is not what we want, we should have
>      [mem 0x00200000-0x3fffffff] page 2M
>      [mem 0x40000000-0x7bffffff] page 1G

What this changelog does not mention, why does the erroneous entry result 
in a kernel panic? It looks like a valid range, so a crash is unexpected.

(This is worth explaining, even if the fix for that is in a separate 
patch.)

Thanks,

	Ingo
