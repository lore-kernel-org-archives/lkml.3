Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbbAEUmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:42:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:10472 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbbAEUmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:42:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="507772112"
From: Andi Kleen <andi@firstfloor.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API to arch_prctl
References: <cover.1419900414.git.luto@amacapital.net>
	<d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>
	<54A64E6D.1020304@linux.intel.com>
Date: Mon, 05 Jan 2015 12:42:08 -0800
In-Reply-To: <54A64E6D.1020304@linux.intel.com> (Dave Hansen's message of
	"Thu, 01 Jan 2015 23:53:17 -0800")
Message-ID: <87mw5x0xjz.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen <dave.hansen@linux.intel.com> writes:

> On 12/29/2014 04:52 PM, Andy Lutomirski wrote:
>> This has the benefit the it avoids cluttering prctl with more
>> arch-specific functionality.  The down side is that arch_prctl will
>> need to be wired up as a 32-bit syscall to add 32-bit support for
>> MPX.
>
> There is existing userspace out there which depends on the existing
> prctl() setup.  There isn't a _lot_ and it might still be able to be
> changed easily, but this isn't a given.
>
> I'll check in with the folks doing the gcc (runtime) part of this next
> week and see what they think.

It'll be quite messy for 32bit because they would need to use syscall(),
as glibc won't have a arch_prctl stub.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
