Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434AbaKFRXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 12:23:03 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:58270 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbaKFRW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 12:22:58 -0500
Message-ID: <545BAE67.1060602@linaro.org>
Date: Thu, 06 Nov 2014 17:22:47 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RESEND PATCH 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
References: <1411555097-16924-1-git-send-email-daniel.thompson@linaro.org>	 <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org> <1415290399.6634.52.camel@perches.com>
In-Reply-To: <1415290399.6634.52.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 16:13, Joe Perches wrote:
> On Thu, 2014-11-06 at 15:27 +0000, Daniel Thompson wrote:
>> Currently when kdb traps printk messages then the raw log level prefix
>> (consisting of '\001' followed by a numeral) does not get stripped off
>> before the message is issued to the various I/O handlers supported by
>> kdb. This causes annoying visual noise as well as causing problems
>> grepping for ^. It is also a change of behaviour compared to normal usage
>> of printk() usage. For example <SysRq>-h ends up with different to that of
>> kdb's "sr h".
>>
>> This patch addresses the problem by stripping log levels from messages
>> before they are issued to the I/O handlers.
> 
> Perhaps instead of stripping the logging level,
> maybe a KERN_SOH_ASCII 'char' sequence should be
> emitted as '<' 'char' '>' (see: printk:print_prefix)
> 
> Maybe this should be added to stable from v3.6
> when KERN_SOH_ASCII was first added.

You mean call the problem a regression and try to restore the original
3.5 behaviour?

Maybe.

However I have to confess that I don't really like the old behaviour.
I'd view it as contradicting the normal behaviours of consoles
(including the kgdbcon console). Why should printk() inside kdb show
different text to printk() outside kdb? For me, having <5> and <c>
scribbled all over the output of an "sr" command (which I think is
probably the heaviest user of printk() inside kdb) never struck me as
adding much value.

Is the above paragraph convincing?

To be honest I'd happy to make the change if this is critical for you
since almost anything is better than dumping a non-printable character
(which does all sorts of different things depending on the combination
of terminal emuluator/screen/minicom I need to access the board or
emulator).

On the other hand if you really mean "perhaps and maybe" then I'd prefer
to leave it as it it.


Daniel.
