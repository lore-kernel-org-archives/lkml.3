Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551Ab3IENdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 09:33:13 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:46900 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3IENdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 09:33:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130905131910.GB22351@mudshark.cambridge.arm.com>
References: <1378317854-25965-1-git-send-email-jean.pihet@linaro.org>
	<1378317854-25965-4-git-send-email-jean.pihet@linaro.org>
	<20130905124508.GE9696@mudshark.cambridge.arm.com>
	<CAORVsuW-1koTMaSMgjagBz1aJ0AtvVRiM5gs3kwO2Fuvk+DhwQ@mail.gmail.com>
	<CAKv+Gu8u4PLVfng8ru4RFwA-+Ky0vYEP3V2=vecqndo5Z0sTJg@mail.gmail.com>
	<20130905131910.GB22351@mudshark.cambridge.arm.com>
Date: Thu, 5 Sep 2013 15:33:10 +0200
Message-ID: <CAFrcx1koLAnNRBtpAhOoTP0SC-wWknY7ipUmcvnjxKqwDOUmag@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf: parse the .debug_frame section in case
 .eh_frame is not present
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jean Pihet <jean.pihet@newoldbits.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Michael Hudson-Doyle <michael.hudson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 September 2013 15:19, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Sep 05, 2013 at 02:17:30PM +0100, Ard Biesheuvel wrote:
>> On 5 September 2013 15:05, Jean Pihet <jean.pihet@newoldbits.com> wrote:
>> [..]
>> > Here are the commands I have been using:
>> >  perf record -g dwarf -- <binary to profile>
>> >  perf report --sort symbol --call-graph --stdio
>> >
>>
>> Ah, I failed to add the 'dwarf' after -g, however, in that case, my
>> perf report segfaults:
>
> Same SEGV here.
Ouch! I never got the segfault on my side.

Here is the setup I am using:
- OMAP4 Pandaboard,
- 13.07 Ubuntu dist from http://www.linaro.org/downloads/,
- 3.11 mainline kernel + 3 patches for unwinding info,
- patched perf tool,
- dbg flavor of the libs installed. Without them installed I do not
get the address resolved but no segfaults

Can you check if the linked libraries contain the .debug_frame
sections? (ldd; readelf -S /lib/arm-linux-gnueabihf/libc-2.17.so|grep
debug_frame; readelf -S
/usr/lib/debug/lib/arm-linux-gnueabihf/libc-2.17.so|grep debug_frame)?

>
> Will

Jean
