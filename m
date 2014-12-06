Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaLFPze (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 10:55:34 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33453 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbaLFPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 10:55:33 -0500
Message-ID: <54832761.1050700@gmail.com>
Date: Sat, 06 Dec 2014 23:57:21 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "jejb@parisc-linux.org" <jejb@parisc-linux.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-parisc@vger.kernel.org" <linux-parisc@vger.kernel.org>,
        Joel Brobecker <brobecker@adacore.com>
Subject: Re: [PATCH] arch: uapi: asm: mman.h: Let MADV_FREE have same value
 for all architectures
References: <5480E715.3020900@gmail.com> <20141205065417.GA3358@bbox> <54822B19.2070804@gmail.com>
In-Reply-To: <54822B19.2070804@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

After this patch, our parisc can pass allmodconfig in linux next tree,
for me, we can say parisc specific code have no touch for allmodconfig.
:-)

But for parisc gcc latest upstream compiler, I found several issues, and
I shall try to analyse them and communicate with gcc related members.

And I also want to consult about parisc assembly instructions, I can not
find the related reference documents, could you help to have a check (or
provide some related information for it)? related contents are below:

  parisc support several store instructions: 'stb' (for store byte),
  'stw(m)' (for store word), and 'std' (for store double word).

  They should be in the same format in binary code, and have neighbour
  numbers, and 'stw(m)' need be in the middle of 'stb' and 'std'. one
  sample for the instruction 'inst' (it is 'unsigned int'):

   - for ((inst >> 26) != 0x3):

     stb: 0x18, or 0x19,
     stw: 0x1a, stwm: 0x1b,
     std: 0x1c.

   - else ((inst >> 26) == 0x3), need check '(inst >> 6) & 0xf':

     stb: 0x08, or 0x09,
     stw: 0x0a,
     std: 0x0b.

  it is about my binutils/gdb patch for parisc, gdb want to recognize
  'st??' to find the position for saving relate context (registers).


Welcome any suggestions, ideas, and completions.

Thanks.


On 12/06/2014 06:00 AM, Chen Gang wrote:
> On 12/05/2014 02:54 PM, Minchan Kim wrote:
>> On Fri, Dec 05, 2014 at 06:58:29AM +0800, Chen Gang wrote:
>>> For uapi, need try to let all macros have same value, and MADV_FREE is
>>> added into main branch recently, so need redefine MADV_FREE for it.
>>>
>>> At present, '8' can be shared with all architectures, so redefine it to
>>> '8'.
>>>
>>> Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
>>
>>
>> Hello Chen,
>>
>> Thanks for looking at this.
>> Feel free to add my sign.
>>
>> Acked-by: Minchan Kim <minchan@kernel.org>
>>
> 
> OK, thanks.
> 
> Originally I sent the same patch like you sent (but later than yours).
> Geert suggested to use same value for MADV_FREE, and Carlos confirmed
> it and suggested more things (sorry, I forgot to Cc them in this mail).
> 
> 
> Thanks.
> 


-- 
Chen Gang

Open share and attitude like air water and life which God blessed
