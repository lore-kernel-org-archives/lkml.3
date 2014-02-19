Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbaBSN7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 08:59:32 -0500
Received: from eu1sys200aog118.obsmtp.com ([207.126.144.145]:37112 "EHLO
	eu1sys200aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753743AbaBSN7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 08:59:30 -0500
Message-ID: <5304B849.2080806@st.com>
Date: Wed, 19 Feb 2014 14:57:29 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: srinivas kandagatla <srinivas.kandagatla@st.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Mark Rutland <mark.rutland@arm.com>, <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, <kernel@stlinux.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Olof Johansson <olof@lixom.net>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stephen.gallimore@st.com>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 0/6] ARM: STi reset controller support
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>		<1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>	<1391592486.11239.4.camel@pizza.hi.pengutronix.de> <52F4D76F.8070301@st.com>
In-Reply-To: <52F4D76F.8070301@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Philipp,

On 02/07/2014 01:54 PM, srinivas kandagatla wrote:
> Hi Philipp,
> Thankyou for looking at the patches.
>
>
> On 05/02/14 09:28, Philipp Zabel wrote:
>> Hi Srinivas,
>>
> ...
>>
>> the patchset looks good to me for the soft resets. But for the powerdown
>> bits I am wondering whether the reset controller API is the right
>> abstraction. Depending on whether those bits really just put the IPs
>> into reset or there is some power gating / sequencing involved,
>> shouldn't this rather be handled as a set of pm domains?
>
> The hardware name of these control signals into the devices is
> slightly unfortunate and a bit misleading. We do not generally
> have separate power domains for peripheral devices in our
> current STB SoCs, in the sense that the voltage cannot actually be
> removed from individual devices. In the USB case we believe the
> powerdown signals internally gate off two of the three
> incoming clocks to most of the USB controller's logic blocks,
> essentially holding the device in a disabled (enable/disable
> might have been a better name for the signal) state.
>
> The primary requirement to manipulate these signals is to bring
> the device out of its cold boot default powerdown/disabled/reset
> (whatever you want to call it) state when the device is probed or
> after a SoC wide power loss when resuming from PM_SUSPEND_MEM.
>
>
>> I see that for example on STiH415 there are both soft resets and
>> powerdown bits for USB[012].
>
> Our IPs typically have two or sometimes three signals going into
> them, controlled from outside of the IP block itself (typically using
> SoC global system configuration registers) that you could view
> as "reset-a-like"; that is toggling each of the signals puts the IP
> into a state where it is in some way unusable and then back to
> being useable again. The reset controller API appeared to be the
> natural abstraction for the drivers to be given access to such control
> signals, regardless of the precise effect the signals have on the
> device's internal state.
>
> With regards to sequencing between these signals; it is the case that
> there is a likely sequencing because at least in the USB case it is
> thought that the "powerdown" stops the clock going to the reset chain
> logic. But we did not see that as an issue as the reset controller
> framework allows for multiple named "reset" lines being defined for
> a device through its DT attributes. The driver knows which signal
> is which and what each does, because it asks for them by name;
> therefore, it knows how to impose any required ordering when changing
> the state of those signals.
>

Did Srini's explanations convinced you?

If so, could you queue the series for v3.15?

Thanks,
Maxime

>
> Thanks,
> srini
>
>
> _______________________________________________
