Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaANScJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 13:32:09 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:49396 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaANScH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 13:32:07 -0500
MIME-Version: 1.0
In-Reply-To: <52D55F92.8040108@linux.intel.com>
References: <20140114133125.GB26942@localhost>
	<52D55F92.8040108@linux.intel.com>
Date: Tue, 14 Jan 2014 10:32:06 -0800
X-Google-Sender-Auth: yOgPg_IJx83N-jJ5EB14mktWtYw
Message-ID: <CAGXu5j+eWG8h_+K9pn42u9tXWrjc6tWthNGURhd8yfM2ODeMyw@mail.gmail.com>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 8:02 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 01/14/2014 05:31 AM, Fengguang Wu wrote:
>> Greetings,
>>
>> I got the below dmesg and the first bad commit is
>>
>> commit 82fa9637a2ba285bcc7c5050c73010b2c1b3d803
>> Author:     Kees Cook <keescook@chromium.org>
>> AuthorDate: Thu Oct 10 17:18:16 2013 -0700
>> Commit:     H. Peter Anvin <hpa@linux.intel.com>
>> CommitDate: Sun Oct 13 03:12:19 2013 -0700
>>
>>     x86, kaslr: Select random position from e820 maps
>>
>>     Counts available alignment positions across all e820 maps, and chooses
>>     one randomly for the new kernel base address, making sure not to collide
>>     with unsafe memory areas.
>>
>>     Signed-off-by: Kees Cook <keescook@chromium.org>
>>     Link: http://lkml.kernel.org/r/1381450698-28710-5-git-send-email-keescook@chromium.org
>>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>>
>> Note that there are many other warning/errors and it's not very
>> reproducible, so this report might be wrong.
>>
>> ===================================================
>> PARENT COMMIT NOT CLEAN. LOOK OUT FOR WRONG BISECT!
>> ===================================================
>>
>
> I wonder if this is in any way related to the fact that the ELF parser
> we have in the decompressor is quite frankly complete crap... it assumes
> that all sections can only be moved downward.

Not that this would change the code here, but I notice tip:x86/kaslr
isn't fully up to date. It's still missing the two most recent
commits:

https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=kaslr-c-v8

"x86, kaslr: clarify RANDOMIZE_BASE_MAX_OFFSET"
"x86, kaslr: remove unused including <linux/version.h>"

-Kees

-- 
Kees Cook
Chrome OS Security
