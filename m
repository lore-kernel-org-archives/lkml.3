Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab3JBQ0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 12:26:04 -0400
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:42403 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753658Ab3JBQ0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 12:26:01 -0400
Message-ID: <524C482E.3050003@st.com>
Date: Wed, 02 Oct 2013 17:22:06 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] media: rc: OF: Add Generic bindings for remote-control
References: <1380274391-26577-1-git-send-email-srinivas.kandagatla@st.com> <20130927113458.GB18672@e106331-lin.cambridge.arm.com> <52458774.1060909@st.com> <20130927105716.64349f02@samsung.com> <524935D6.1010505@st.com> <20131001114949.5a26dd70.m.chehab@samsung.com>
In-Reply-To: <20131001114949.5a26dd70.m.chehab@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/13 15:49, Mauro Carvalho Chehab wrote:
>>> > > 
>>> > > Btw, we're even thinking on mapping HDMI-CEC remote controller RX/TX via
>>> > > the RC subsystem. So, another L1 protocol would be "hdmi-cec".
>>> > > 
>> > Ok.
>>> > > Yet, it seems unlikely that the very same remote controller IP would use
>>> > > a different protocol for RX and TX, while sharing the same registers.
>> > 
>> > ST IRB block has one IR processor which has both TX and RX support and
>> > one UHF Processor which has RX support only. However the register map
>> > for all these support is in single IRB IP block.
>> > 
>> > So the driver can configure the IP as TX in "infrared" and RX in "uhf".
>> > This is supported in ST IRB IP.
>> > 
>> > This case can not be represented in a single device tree node with
>> > l1-protocol and direction properties.
>> > 
>> > IMHO, having tx-mode and rx-mode or tx-protocol and rx-protocol
>> > properties will give more flexibility.
>> > 
>> > What do you think?
> Yeah, if they're using the same registers, then your proposal works
> better.
> 
> I would prefer to not call it as just protocol, as IR has an
> upper layer protocol that defines how the bits are encoded, e. g.
> RC5, RC6, NEC, SONY, ..., with is what we generally call as protocol
> on rc-core. 
> 
> A proper naming for it is hard to find. Well, for IR/UHF, it is actually

Yes I agree.

> specifying the medium, but for Bluetooth, HDMI-CEC, it defines a
> protocol stack to be used, with covers not only the physical layer of
> the OSI model.
> 
> Perhaps the better would be to call it as: tx-proto-stack/rx-proto-stack.
> 
How are we going to address use case highlighted by Mark R, like N
Connections on a single IP block?

This use-case can not be addressed with tx-mode and rx-mode or
tx-proto-stack/rx-proto-stack properties.

So the idea of generic properties for tx and rx sounds incorrect.

IMHO, Best thing would be to drop the idea of using tx-mode and rx-mode
as generic properties and use "st,tx-mode" and "st,rx-mode" instead for
st-rc driver.

What do you think?

Thanks,
srini


