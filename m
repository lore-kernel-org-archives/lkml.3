Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938Ab3EUHwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:52:32 -0400
Received: from intranet.asianux.com ([58.214.24.6]:2866 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677Ab3EUHwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:52:30 -0400
X-Spam-Score: -100.8
Message-ID: <519B278B.6030708@asianux.com>
Date: Tue, 21 May 2013 15:51:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
References: <5199B7D6.40907@asianux.com> <20130520091008.GB31359@mudshark.cambridge.arm.com> <519AE6D7.1090401@asianux.com> <CAMuHMdWNHPDkf35MYMKnxt5pn3a+dsT4jgYxuuHrp+mpZMckfw@mail.gmail.com>
In-Reply-To: <CAMuHMdWNHPDkf35MYMKnxt5pn3a+dsT4jgYxuuHrp+mpZMckfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 02:57 PM, Geert Uytterhoeven wrote:
> On Tue, May 21, 2013 at 5:15 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> >> I think it would be better if we added a something like
>>> >> CONFIG_HAVE_VGA_CONSOLE, which VGA_CONSOLE can then depend on. Architectures
>>> >> like x86 can then select the former, and we can remove the long list of
>>> >> architectures from the current option.
>> >
>> > I guess your meaning is:
>> >
>> >   under arm64, actually, need not support 'VGA_CONSOLE', and 'screen_info' is useless.
>> >   So better to define 'CONFIG_HAVE_VGA_CONSOLE' which 'VGA_CONSOLE' can depend on it, and in arm64, we do not define CONFIG_HAVE_VGA_CONSOLE.
>> >
>> > Is it correct ?
> No, you missed "and we can remove the long list of architectures from the
> current option".
> 

OK, thanks.

Is it correct: "it is unnecessary to add 'screen_info' to the code, for
arm64 will never support 'VGA_CONSOLE'" ?


>> > If so, I recommend to add depend item for VGA_CONSOLE directly:
> I strongly support CONFIG_HAVE_VGA_CONSOLE.

For me, I still recommend add 'ARM64' in the long list of architectures
for 'VGA_CONSOLE', I have 3 reasons, please check:

a. current implementation only changes one area which only related with
arm64 and 'VGA_CONSOLE', but if use 'CONFIG_HAVE_VGA_CONSOLE', that will
touch many multiple platforms dependency, at least we need discuss about
it with multiple platforms guys for it, firstly.

b. We can find some cases to use CONFIG_HAVE_* as dpend on, but I can
not find any cases which let CONFIG_'samename' depend on
CONFIG_HAVE_'samename'.

c. The original way still has effect, although it seems not quit
beautiful, but it is correct and still clear for readers, it is still
sustainable.


Thanks.
-- 
Chen Gang

Asianux Corporation
