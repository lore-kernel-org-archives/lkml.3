Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3J2ItD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:49:03 -0400
Received: from intranet.asianux.com ([58.214.24.6]:14343 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751408Ab3J2ItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 04:49:00 -0400
X-Spam-Score: -100.7
Message-ID: <526F763B.6020806@asianux.com>
Date: Tue, 29 Oct 2013 16:47:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Max Filippov <jcmvbkbc@gmail.com>
CC: "vgupta@synopsys.com" <vgupta@synopsys.com>,
        James Hogan <james.hogan@imgtec.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: use ASM_NL instead of ';' for assembler new line
 character in the macro
References: <526E3CE2.2070405@asianux.com> <CAMo8BfK70vRc_DUTXhUZfTjA7zvYW3D4ApgDoMrwUZp5c+qk1g@mail.gmail.com> <526F6A4F.9040507@asianux.com> <CAMo8BfK3FfQ+Gh=XMnaHZQqDayNN455DgMcbnKZBQTumC+_WmA@mail.gmail.com>
In-Reply-To: <CAMo8BfK3FfQ+Gh=XMnaHZQqDayNN455DgMcbnKZBQTumC+_WmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 04:34 PM, Max Filippov wrote:
> On Tue, Oct 29, 2013 at 11:57 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> On 10/28/2013 07:18 PM, Max Filippov wrote:
>>> Hi Chen,
>>>
>>> On Mon, Oct 28, 2013 at 2:30 PM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>> For some toolchains, they use another character as newline in a macro
>>>>> (e.g. arc uses '`'), so for generic assembly code, need use ASM_NL (a
>>>>> macro) instead of ';' for it.
>>>>> Since "linux/export.h" are mainly used for exporting work, then our fix
>>>>> more likely belongs to "linux/linkage.h", and we need add the related
>>>>> checking in "linkage.h".
>>>>>
>>>>> Also need notice 80 columns wrap, and '\t' for each line.
>>>>>
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>> ---
>>>>>  arch/arc/include/asm/linkage.h    |    2 +
>>>>>  include/asm-generic/vmlinux.lds.h |  350 +++++++++++++++++++------------------
>>> Actually vmlinux.lds.h is not an assembly code, but rather a linker script,
>>> later preprocessed by cpp.
>>>
>>
>> Consult: do xtensa also has its own ASM_NL?
> 
> It works well with common semicolon.
> 

Thank you for your confirmation.


After scan the "arch/" sub-directory, except arc, the cris, c6x, frv,
and parisc are also use ';' as comments, I guess they will welcome this
patch.

And some of another architectures may use '#', '|', '!', '@' or "//" as
line comment mark. It seems most of them support ';' as newline in the
macro, but it is also necessary to give a check.

If this patch is applied, I will/should sync all the related
architectures to let ASM_NL consistency.

:-)

Thanks.
-- 
Chen Gang
