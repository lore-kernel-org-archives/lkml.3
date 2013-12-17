Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3LQFcl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:32:41 -0500
Received: from mail-qa0-f41.google.com ([209.85.216.41]:48914 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3LQFcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:32:39 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CANqRtoSH88L9riQNodA6qBbfvU6DYJc2U-=4KhsjBu-qAjPFjQ@mail.gmail.com>
References: <20131211235616.12661.19702.sendpatchset@w520>
	<20131211235626.12661.8865.sendpatchset@w520>
	<20131212010503.GI21531@quad.lixom.net>
	<CANqRtoTGuXnGT0LW+et0w6U6QOC8x8xx0OEEqxQH8X6EtWrEcg@mail.gmail.com>
	<20131216053950.GA5822@quad.lixom.net>
	<CANqRtoSH88L9riQNodA6qBbfvU6DYJc2U-=4KhsjBu-qAjPFjQ@mail.gmail.com>
Date: Mon, 16 Dec 2013 21:32:38 -0800
Message-ID: <CAOesGMivkshW-9gtSxO+eymQ-QXuTrmf1+uS5hzr7NO9gbaPgw@mail.gmail.com>
Subject: Re: [PATCH v4 01/03] clocksource: Add Kconfig entries for CMT, MTU2,
 TMU and STI
From: Olof Johansson <olof@lixom.net>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Kevin Hilman <khilman@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        SH-Linux <linux-sh@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 9:28 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
> Hi Olof,
>
> On Mon, Dec 16, 2013 at 2:39 PM, Olof Johansson <olof@lixom.net> wrote:
>> On Fri, Dec 13, 2013 at 07:12:58PM +0900, Magnus Damm wrote:
>>> Hi Olof,
>>>
>>> On Thu, Dec 12, 2013 at 10:05 AM, Olof Johansson <olof@lixom.net> wrote:
>>> > Hi,
>>> >
>>> > A couple of small comments below.
>>>
>>> Thanks for your feedback!
>>>
>>> > On Thu, Dec 12, 2013 at 08:56:26AM +0900, Magnus Damm wrote:
>>> >> From: Magnus Damm <damm@opensource.se>
>>> >>
>>> >> Add Kconfig entries for CMT, MTU2, TMU and STI to
>>> >> drivers/clocksource/Kconfig. This will allow us to
>>> >> get rid of duplicated entires in architecture code
>>> >> such as arch/sh and arch/arm/mach-shmobile.
>>> >>
>>> >> Signed-off-by: Magnus Damm <damm@opensource.se>
>>> >> ---
>>> >>
>>> >>  drivers/clocksource/Kconfig |   44 +++++++++++++++++++++++++++++++++++++++++++
>>> >>  1 file changed, 44 insertions(+)
>>> >>
>>> >> --- 0001/drivers/clocksource/Kconfig
>>> >> +++ work/drivers/clocksource/Kconfig  2013-12-12 08:41:55.000000000 +0900
>>> >> @@ -134,3 +134,47 @@ config VF_PIT_TIMER
>>> >>       bool
>>> >>       help
>>> >>         Support for Period Interrupt Timer on Freescale Vybrid Family SoCs.
>>> >> +
>>> >> +config SYS_SUPPORTS_CMT
>>> >> +        bool
>>> >> +
>>> >> +config SYS_SUPPORTS_TMU
>>> >> +        bool
>>> >> +
>>> >> +config SYS_SUPPORTS_MTU2
>>> >> +        bool
>>> >> +
>>> >> +config SYS_SUPPORTS_STI
>>> >> +        bool
>>> >
>>> > Maybe a prefix to avoid namespace collissions here?
>>>
>>> Sure, that is fine with me. I based the ones above on already existing
>>> ones used by SH but I don't mind reworking those.
>>>
>>> How about SYS_SUPPORTS_CLKSRC_xxx?
>>
>> Oh, I was hoping for something shmobile-specific. Other platforms might have
>> some other clock source that they name STI or MTU, for example.
>
> Thanks for the clarification. So how about the following?
>
> SYS_SUPPORTS_SH_CMT
> SYS_SUPPORTS_SH_MTU2
> SYS_SUPPORTS_SH_TMU
> SYS_SUPPORTS_EM_STI
>
> The above match the style of the existing CONFIG_ SH/EM _TIMER_
> CMT/MTU2/TMU/STI. Regarding the SH vs EM prefix, the SH ones are
> present on arch/sh while EM_STI is only present on Emma Mobile SoCs.

Yep, that sounds good.


-Olof
