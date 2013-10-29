Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757855Ab3J2BkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:40:16 -0400
Received: from intranet.asianux.com ([58.214.24.6]:28923 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3J2BkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:40:14 -0400
X-Spam-Score: -106.8
Message-ID: <526F11C0.1030809@asianux.com>
Date: Tue, 29 Oct 2013 09:39:12 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Vineet Gupta <vineetg76@gmail.com>, James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [PATCH] arch: use ASM_NL instead of ';' for assembler new line
 character in the macro
References: <526E3CE2.2070405@asianux.com> <526E6A92.6090301@synopsys.com> <526F09B8.9030202@asianux.com>
In-Reply-To: <526F09B8.9030202@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 09:04 AM, Chen Gang wrote:
> On 10/28/2013 09:45 PM, Vineet Gupta wrote:
>> On 10/28/2013 04:00 PM, Chen Gang wrote:
>>> For some toolchains, they use another character as newline in a macro
>>> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
>>> macro) instead of ';' for it.
>>>
>>> Since "linux/export.h" are mainly used for exporting work, then our fix
>>> more likely belongs to "linux/linkage.h", and we need add the related
>>> checking in "linkage.h".
>>>
>>> Also need notice 80 columns wrap, and '\t' for each line.
>>>
>>>
>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>> ---
>>>  arch/arc/include/asm/linkage.h    |    2 +
>>>  include/asm-generic/vmlinux.lds.h |  350 +++++++++++++++++++------------------
>>>  include/linux/linkage.h           |   19 +
>>
>> Like Max said, please drop the linker script bits - they are OK - otherwise ARC
>> kernel won't have been building at all.
>>
> 
> OK, thank you and Max, I will send patch v2 for it.
> 
> Hmm... after this modification, it passed allmodconfig for x86_64. And
> for arc, at least, it can build to "mm/" sub-directory (after here, I
> stopped compiling).

It seems I should not stopped when build to "mm/" sub-directory -- that
will let myself find: "ld and as are really 'individual' enough,
although both of them belong binutils".  :-)


> 
> 
>> And you also need to fix kernel/modsign_certificate.S as part of same patchset as
>> that is where the problem started in first place.
>>
> 
> Hmm... can that be another patch?
> 
> For "kernel/modsign_certificate.S", I recommend to expand the macro
> which will shrink code line, either need not include additional header
> file, I feel that will be simpler for both code reader and writers.
> 
> 
> Thanks.
> 


-- 
Chen Gang
