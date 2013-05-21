Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3EUKOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:14:01 -0400
Received: from intranet.asianux.com ([58.214.24.6]:62926 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab3EUKN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:13:59 -0400
X-Spam-Score: -100.8
Message-ID: <519B48B4.6050607@asianux.com>
Date: Tue, 21 May 2013 18:13:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
References: <5199B7D6.40907@asianux.com> <20130520091008.GB31359@mudshark.cambridge.arm.com> <519AE6D7.1090401@asianux.com> <CAMuHMdWNHPDkf35MYMKnxt5pn3a+dsT4jgYxuuHrp+mpZMckfw@mail.gmail.com> <519B278B.6030708@asianux.com> <20130521090336.GC10453@mudshark.cambridge.arm.com>
In-Reply-To: <20130521090336.GC10453@mudshark.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 05:03 PM, Will Deacon wrote:
> On Tue, May 21, 2013 at 08:51:39AM +0100, Chen Gang wrote:
>> On 05/21/2013 02:57 PM, Geert Uytterhoeven wrote:
>>> On Tue, May 21, 2013 at 5:15 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>>>> I think it would be better if we added a something like
>>>>>>> CONFIG_HAVE_VGA_CONSOLE, which VGA_CONSOLE can then depend on. Architectures
>>>>>>> like x86 can then select the former, and we can remove the long list of
>>>>>>> architectures from the current option.
>>>>>
>>>>> I guess your meaning is:
>>>>>
>>>>>   under arm64, actually, need not support 'VGA_CONSOLE', and 'screen_info' is useless.
>>>>>   So better to define 'CONFIG_HAVE_VGA_CONSOLE' which 'VGA_CONSOLE' can depend on it, and in arm64, we do not define CONFIG_HAVE_VGA_CONSOLE.
>>>>>
>>>>> Is it correct ?
>>> No, you missed "and we can remove the long list of architectures from the
>>> current option".
>>>
>>
>> OK, thanks.
>>
>> Is it correct: "it is unnecessary to add 'screen_info' to the code, for
>> arm64 will never support 'VGA_CONSOLE'" ?
> 
> We can add the screen_info if and when we need to support a VGA console. In
> the meantime, let's not add things on a whim.
> 

OK, thanks. At least now (for our case), need not add 'screen_info', is
it correct ?


>>>>> If so, I recommend to add depend item for VGA_CONSOLE directly:
>>> I strongly support CONFIG_HAVE_VGA_CONSOLE.
>>
>> For me, I still recommend add 'ARM64' in the long list of architectures
>> for 'VGA_CONSOLE', I have 3 reasons, please check:
>>
>> a. current implementation only changes one area which only related with
>> arm64 and 'VGA_CONSOLE', but if use 'CONFIG_HAVE_VGA_CONSOLE', that will
>> touch many multiple platforms dependency, at least we need discuss about
>> it with multiple platforms guys for it, firstly.
> 
> That's a weak argument. You might as well propose the cleanup and see what
> people say.
> 

Hmm.. I think at least, we need discuss it with the 'final applier'
firstly (and now, I even do not know who is the 'final applier').


>> b. We can find some cases to use CONFIG_HAVE_* as dpend on, but I can
>> not find any cases which let CONFIG_'samename' depend on
>> CONFIG_HAVE_'samename'.
> 
> Erm. PERF_EVENTS, BPF_JIT, IDE, ...?
> 

CONFIG_PERF_EVENTS is not directly depend on CONFIG_HAVE_PERF_EVENTS.
CONFIG_BPF_JIT is not directly depend on CONFIG_HAVE_BPF_JIT.
CONFIG_IDE is not directly depend on CONFIG_HAVE_IDE.
...

But I guess what we will do is to let "CONFIG_VGA_CONSOLE is directly
depend on CONFIG_HAVE_VGA_CONSOLE".

So I think we really need discuss it firstly with the 'final applier'.


>> c. The original way still has effect, although it seems not quit
>> beautiful, but it is correct and still clear for readers, it is still
>> sustainable.
> 
> Sure, it works, but we're just contributing to the mess that's been built up
> ever time another architecture has done the same thing. It's not hard to try
> and clean it up.
> 

Can we separate into 2 patches ?. One is for current compiling issue
with allmodconfig (the priority is a litter higher), the other is for
fixup patch (the priority is lower).  ;-)


BTW: In fact, if we really need send the related fixup patch, I am also
unwilling to do that, I guess (in my experience), the fixup patch like
that, will never be applied. :-(


Thanks.
-- 
Chen Gang

Asianux Corporation
