Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761597Ab3LIWkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 17:40:07 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:49202 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab3LIWkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 17:40:04 -0500
Message-ID: <52A646AB.1030900@ti.com>
Date: Mon, 9 Dec 2013 17:39:39 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 01/23] mm/memblock: debug: correct displaying of upper
 memory boundary
References: <1386625856-12942-1-git-send-email-santosh.shilimkar@ti.com> <1386625856-12942-2-git-send-email-santosh.shilimkar@ti.com> <20131209215641.GF29143@saruman.home>
In-Reply-To: <20131209215641.GF29143@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 December 2013 04:56 PM, Felipe Balbi wrote:
> On Mon, Dec 09, 2013 at 04:50:34PM -0500, Santosh Shilimkar wrote:
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>>
>> When debugging is enabled (cmdline has "memblock=debug") the memblock
>> will display upper memory boundary per each allocated/freed memory range
>> wrongly. For example:
>>  memblock_reserve: [0x0000009e7e8000-0x0000009e7ed000] _memblock_early_alloc_try_nid_nopanic+0xfc/0x12c
>>
>> The 0x0000009e7ed000 is displayed instead of 0x0000009e7ecfff
>>
>> Hence, correct this by changing formula used to calculate upper memory
>> boundary to (u64)base + size - 1 instead of  (u64)base + size everywhere
>> in the debug messages.
>>
>> Cc: Yinghai Lu <yinghai@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Tejun Heo <tj@kernel.org>
>> Acked-by: Tejun Heo <tj@kernel.org>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
> 
> Very minor patch but perhaps we should Cc: stable here ? not that it
> matters much...
> 
Yeah... No major fix as such from stable perspective.

regards,
Santosh
