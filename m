Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868AbaIQEE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 00:04:27 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:62543 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaIQEE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 00:04:26 -0400
Message-ID: <54190846.9060601@martingkelly.com>
Date: Tue, 16 Sep 2014 21:04:22 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>, x86@kernel.org, mingo@redhat.com
CC: vishwesh.m.rudramuni@intel.com, joe@perches.com, hpa@linux.intel.com,
        linux-kernel@vger.kernel.org, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86/pmc_atom: Fix warning when CONFIG_DEBUG_FS=n
References: <1410914975-23285-1-git-send-email-martin@martingkelly.com> <5418ED4A.2030607@linux.intel.com> <5418FDEC.40201@martingkelly.com> <541903A9.7090301@linux.intel.com>
In-Reply-To: <541903A9.7090301@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 08:44 PM, Li, Aubrey wrote:
> 
> Why do you want to call pmc_dbgfs_register() anyway even if
> CONFIG_DEBUG_FS=n?
> 
> Thanks,
> -Aubrey
> 

The compiler will optimize away the call when CONFIG_DEBUG_FS=n, as the function body is just "return 0". Since the line following the call is "if (ret)" and since ret will always be 0, the compiler will likely optimize away the branch as well.

The reasoning for doing it this way is that it gives you a uniform code flow, which is easier to follow and reason about than having to think about branching #ifdefs sprinkled throughout the functions. The link I pasted gives full detail, but here's a snippet from Linus:

"Code cluttered with ifdefs is difficult to read and maintain.  Don't do
it.  Instead, put your ifdefs in a header, and conditionally define
'static inline' functions, or macros, which are used in the code.
Let the compiler optimize away the "no-op" case."

https://www.kernel.org/doc/Documentation/SubmittingPatches
(section 2.2, "#ifdefs are ugly")

In addition, Ingo Molnar suggested that I revise the patch in this way.

Thanks,
Martin
