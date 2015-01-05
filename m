Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032AbbAEVS3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:18:29 -0500
Received: from mga03.intel.com ([134.134.136.65]:45227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbbAEVS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:18:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,702,1413270000"; 
   d="scan'208";a="632845216"
Message-ID: <54AAFFA3.6000901@linux.intel.com>
Date: Mon, 05 Jan 2015 13:18:27 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3.19 3/3] x86, mpx: Change the MPX enable/disable API
 to arch_prctl
References: <cover.1419900414.git.luto@amacapital.net>	<d5efe02b133f6d9fb4cb9d03e0f0b9e17211c06f.1419900414.git.luto@amacapital.net>	<54A64E6D.1020304@linux.intel.com> <87mw5x0xjz.fsf@tassilo.jf.intel.com>
In-Reply-To: <87mw5x0xjz.fsf@tassilo.jf.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2015 12:42 PM, Andi Kleen wrote:
> Dave Hansen <dave.hansen@linux.intel.com> writes:
>> On 12/29/2014 04:52 PM, Andy Lutomirski wrote:
>>> This has the benefit the it avoids cluttering prctl with more
>>> arch-specific functionality.  The down side is that arch_prctl will
>>> need to be wired up as a 32-bit syscall to add 32-bit support for
>>> MPX.
>>
>> There is existing userspace out there which depends on the existing
>> prctl() setup.  There isn't a _lot_ and it might still be able to be
>> changed easily, but this isn't a given.
>>
>> I'll check in with the folks doing the gcc (runtime) part of this next
>> week and see what they think.
> 
> It'll be quite messy for 32bit because they would need to use syscall(),
> as glibc won't have a arch_prctl stub.

Yeah, I'd _really_ prefer not to change it.  The code is in a gcc
branch, but is getting pulled in to the 5.0 release.  We've got
*absolutely* no shortage of prctl numbers.
