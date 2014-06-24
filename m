Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaFXSTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 14:19:46 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:33909 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752899AbaFXSTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 14:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrW_U7z7RC-D5+Ji+PQd73nR-=xQGH5uieb7y3Z7yzYPRw@mail.gmail.com>
References: <2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net>
 <tip-5f56e7167e6d438324fcba87018255d81e201383@git.kernel.org>
 <20140622084754.GA15094@gmail.com> <CALCETrW_U7z7RC-D5+Ji+PQd73nR-=xQGH5uieb7y3Z7yzYPRw@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 24 Jun 2014 11:19:22 -0700
Message-ID: <CALCETrXohybf=Lk70j=hVG1zaAQ-mw8CVo6P59xjM2qsc-p+Gg@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86/vdso: Discard the __bug_table section
To: Ingo Molnar <mingo@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 9:59 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Sun, Jun 22, 2014 at 1:47 AM, Ingo Molnar <mingo@kernel.org> wrote:
>>
>> * tip-bot for Andy Lutomirski <tipbot@zytor.com> wrote:
>>
>>> Commit-ID:  5f56e7167e6d438324fcba87018255d81e201383
>>> Gitweb:     http://git.kernel.org/tip/5f56e7167e6d438324fcba87018255d81e201383
>>> Author:     Andy Lutomirski <luto@amacapital.net>
>>> AuthorDate: Wed, 18 Jun 2014 15:59:46 -0700
>>> Committer:  H. Peter Anvin <hpa@linux.intel.com>
>>> CommitDate: Thu, 19 Jun 2014 15:44:51 -0700
>>>
>>> x86/vdso: Discard the __bug_table section
>>>
>>> It serves no purpose in user code.
>>>
>>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>>> Link: http://lkml.kernel.org/r/2a5bebff42defd8a5e81d96f7dc00f21143c80e8.1403129369.git.luto@amacapital.net
>>> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
>>> ---
>>>  arch/x86/vdso/vdso-layout.lds.S | 1 +
>>>  1 file changed, 1 insertion(+)
>>
>> One of the recent x86/urgent vdso commits causes this build failure:
>>
>>  Error: too many copied sections (max = 13)
>
> I can't reproduce this with your config, which suggestes a binutils
> issue, which is annoying.  Can you tell me what version of ld you're
> using and send me the output of:
>
> for i in arch/x86/vdso/*.so.dbg; do echo $i; eu-readelf -S $i; done

Ping!

The current state of this is obviously not so good, but I don't know
how to proceed.

--Andy
