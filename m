Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBXOMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 09:12:15 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:56620 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752276AbaBXOMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 09:12:13 -0500
Message-ID: <530B514A.4070209@st.com>
Date: Mon, 24 Feb 2014 14:03:54 +0000
From: srinivas kandagatla <srinivas.kandagatla@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>,
        Maxime Coquelin <maxime.coquelin@st.com>
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
References: <1389696613-19683-1-git-send-email-srinivas.kandagatla@st.com>			<1391437665-11913-1-git-send-email-srinivas.kandagatla@st.com>		<1391592486.11239.4.camel@pizza.hi.pengutronix.de>	 <52F4D76F.8070301@st.com> <5304B849.2080806@st.com> <1393237988.3091.14.camel@pizza.hi.pengutronix.de>
In-Reply-To: <1393237988.3091.14.camel@pizza.hi.pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.65.51.147]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Philipp for your comments,

On 24/02/14 10:33, Philipp Zabel wrote:
>> > Did Srini's explanations convinced you?
>> > 
>> > If so, could you queue the series for v3.15?
> to be honest, I'm not comfortable with this explanation. If the
> "powerdown" bits only gate the clocks to those modules, calling it a
> reset control is clearly the wrong abstraction. If that is the case,
> couldn't you handle those bits via the clock framework?
I just had a re-look at the IPs specs for more information on where
these power-down signals are actually terminating on the IP side.

For example: ST-Synopsis Ethernet GMAC IP has two pins
power_down_req[IN] and power_down_ack[OUT]. power_down_req is used by
the software to either put the IP in powerdown or bring it out of
powerdown state.

The IP itself drives power_down_ack to indicate when the power down
request is successfully finished. For power_down/power_up request the IP
will change the internal state accordingly including powering up/down
its internal blocks and/or clock gating.

> If on the other hand these powerdown bits also trigger reset machinery,
> such that asserting and deasserting that bit will change the module's
> internal state, I could be convinced to queue them like this.
This is true with ST IPs, these lines change the state of the IP as
described above. Reset framework seems to fits in very well with this
behavior rather than power-domains or clock framework.

Thanks,
srini




