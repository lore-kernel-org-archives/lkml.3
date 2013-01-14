Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440Ab3ANWDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:03:43 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:52323 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088Ab3ANWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:03:42 -0500
Message-ID: <50F480BB.6070105@gmail.com>
Date: Mon, 14 Jan 2013 14:03:39 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-mips@linux-mips.org, Aaro Koskinen <aaro.koskinen@iki.fi>
Subject: Re: 3.8-rc1 build failure with MIPS/SPARSEMEM
References: <20121222122757.GB6847@blackmetal.musicnaut.iki.fi> <20121226003434.GA27760@otc-wbsnb-06> <20121227121607.GA7097@blackmetal.musicnaut.iki.fi> <20121230103850.GA5424@otc-wbsnb-06> <20130114151641.GA17996@otc-wbsnb-06>
In-Reply-To: <20130114151641.GA17996@otc-wbsnb-06>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 07:16 AM, Kirill A. Shutemov wrote:
> On Sun, Dec 30, 2012 at 12:38:50PM +0200, Kirill A. Shutemov wrote:
>> On Thu, Dec 27, 2012 at 02:16:07PM +0200, Aaro Koskinen wrote:
>>> Hi,
>>>
>>> On Wed, Dec 26, 2012 at 02:34:35AM +0200, Kirill A. Shutemov wrote:
>>>> On MIPS if SPARSEMEM is enabled we've got this:
>>>>
>>>> In file included from /home/kas/git/public/linux/arch/mips/include/asm/pgtable.h:552,
>>>>                   from include/linux/mm.h:44,
>>>>                   from arch/mips/kernel/asm-offsets.c:14:
>>>> include/asm-generic/pgtable.h: In function ‘my_zero_pfn’:
>>>> include/asm-generic/pgtable.h:466: error: implicit declaration of function ‘page_to_section’
>>>> In file included from arch/mips/kernel/asm-offsets.c:14:
>>>> include/linux/mm.h: At top level:
>>>> include/linux/mm.h:738: error: conflicting types for ‘page_to_section’
>>>> include/asm-generic/pgtable.h:466: note: previous implicit declaration of ‘page_to_section’ was here
>>>>
>>>> Due header files inter-dependencies, the only way I see to fix it is
>>>> convert my_zero_pfn() for __HAVE_COLOR_ZERO_PAGE to macros.
>>>>
>>>> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
>>>
>>> Thanks, this works.
>>>
>>> Tested-by: Aaro Koskinen <aaro.koskinen@iki.fi>
>>
>> Andrew, could you take the patch?

I found the same problem and arrived at an equivalent solution.

Acked-by: David Daney <david.daney@cavium.com>

>
> ping?
>

