Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753315AbaEFSQL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:16:11 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:36983 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbaEFSQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:16:09 -0400
Message-ID: <536926DD.30402@oracle.com>
Date: Tue, 06 May 2014 14:15:57 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/6] mm: Postpone the disabling of kmemleak early logging
References: <1399038070-1540-1-git-send-email-catalin.marinas@arm.com> <1399038070-1540-7-git-send-email-catalin.marinas@arm.com> <5368FDBB.8070106@oracle.com> <20140506170549.GM23957@arm.com>
In-Reply-To: <20140506170549.GM23957@arm.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 01:05 PM, Catalin Marinas wrote:
> On Tue, May 06, 2014 at 04:20:27PM +0100, Sasha Levin wrote:
>> On 05/02/2014 09:41 AM, Catalin Marinas wrote:
>>> Currently, kmemleak_early_log is disabled at the beginning of the
>>> kmemleak_init() function, before the full kmemleak tracing is actually
>>> enabled. In this small window, kmem_cache_create() is called by kmemleak
>>> which triggers additional memory allocation that are not traced. This
>>> patch moves the kmemleak_early_log disabling further down and at the
>>> same time with full kmemleak enabling.
>>>
>>> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>
>> This patch makes the kernel die during the boot process:
>>
>> [   24.471801] BUG: unable to handle kernel paging request at ffffffff922f2b93
>> [   24.472496] IP: [<ffffffff922f2b93>] log_early+0x0/0xcd
> 
> Thanks for reporting this. I assume you run with
> CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF enabled and kmemleak_early_log remains
> set even though kmemleak is not in use.
> 
> Does the patch below fix it?

Nope, that didn't help as I don't have DEBUG_KMEMLEAK_DEFAULT_OFF enabled.

For reference:

$ cat .config | grep KMEMLEAK
CONFIG_HAVE_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK=y
CONFIG_DEBUG_KMEMLEAK_EARLY_LOG_SIZE=400
# CONFIG_DEBUG_KMEMLEAK_TEST is not set
# CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is not set


Thanks,
Sasha
