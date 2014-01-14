Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751689AbaANPvm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 10:51:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:42179 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANPvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 10:51:38 -0500
Message-ID: <52D55CE5.1060902@ti.com>
Date: Tue, 14 Jan 2014 09:51:01 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
CC: Tero Kristo <t-kristo@ti.com>, Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP4: sleep: byteswap data for big-endian
References: <1389625399-24087-1-git-send-email-taras.kondratiuk@linaro.org>	<52D404DE.2020806@ti.com> <CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com>
In-Reply-To: <CAArO44samX_uMeC93w4DBbC+yskEmrvVt_i-5VV_seatM56ypw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 05:14 AM, Taras Kondratiuk wrote:
> On 13 January 2014 17:23, Nishanth Menon <nm@ti.com> wrote:
>> On 01/13/2014 09:03 AM, Taras Kondratiuk wrote:
>>> From: Victor Kamensky <victor.kamensky@linaro.org>
>>>
>>> Assembler functions defined in sleep44xx.S need to byteswap values
>>> after read / before write from h/w register if code compiled in big
>>> endian mode. Simple change to do 'rev x, x' before str instruction
>>> and after ldr instruction that deals with h/w registers.
>>>
>>> Signed-off-by: Victor Kamensky <victor.kamensky@linaro.org>
>>> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
>>> ---
>>> This is a part of RFC series [1].
>>> Based on v3.13-rc8.
>>>
>>> [1] http://www.spinics.net/lists/linux-omap/msg99927.html
>>>
>>>  arch/arm/mach-omap2/sleep44xx.S |   17 +++++++++++++++++
>>>  1 file changed, 17 insertions(+)
>>>
>>
>> OMAP4 is LE, and if there is a gcc flag for the same, is'nt it cleaner
>> to deal with it in Makefile rather than trying to make an assembly
>> meant only for LE by force building it for BE?
> 
> Hi Nishanth
> I'm not sure I got your point.
> Do you propose to build this file as LE while the rest of kernel is BE?
> 
I dont see why I should deal with the BE macro for every code change
we have in omap4,am335x assembly. The hardware is LE and wont change
just coz you are building it for BE. So I dont get the rationale for
changing the assembly here - yes, if the assembly can be maintained as
LE only mode and the build handling be adequately handled in Makefile
(similar to SMC handling), that would be the best.

is the idea of BE build meant to deal with having a single BE kernel
build work for all platforms (including LE ones)?

-- 
Regards,
Nishanth Menon
