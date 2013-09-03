Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab3ICFZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 01:25:13 -0400
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:5376 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759376Ab3ICFZL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 01:25:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzbb2dI98dI9371I1432I853kzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h1de097h8275bhz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: RE: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Thread-Topic: [PATCH 4/4] Documentation: Add device tree bindings for
 Freescale FTM PWM
Thread-Index: AQHOnhwezjS9uM7qaEqpBdTwwEdnOZmuL2UAgAAOvACABU58cA==
Date: Tue, 3 Sep 2013 05:25:05 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827F7CCF@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-5-git-send-email-Li.Xiubo@freescale.com>
 <5EFBF478-CFCC-4E66-A279-25F4A338B05B@kernel.crashing.org>
 <5220FC8C.90908@wwwdotorg.org>
In-Reply-To: <5220FC8C.90908@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH 4/4] Documentation: Add device tree bindings for
> Freescale FTM PWM
> 
> On 08/30/2013 01:19 PM, Kumar Gala wrote:
> > Should have at least something w/regards to a commit message.
> >
> > On Aug 20, 2013, at 10:07 PM, Xiubo Li wrote:
> >
> >> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> >> ---
> >> .../devicetree/bindings/pwm/fsl-ftm-pwm.txt        | 52
> ++++++++++++++++++++++
> >> 1 file changed, 52 insertions(+)
> >> create mode 100644
> >> Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> >> b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> >> new file mode 100644
> >> index 0000000..698965b
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/pwm/fsl-ftm-pwm.txt
> >> @@ -0,0 +1,52 @@
> >> +Freescale FTM PWM controller
> >> +
> >> +Required properties:
> >> +- compatible: should be "fsl,vf610-ftm-pwm"
> >> +- reg: physical base address and length of the controller's
> >> +registers
> >> +- #pwm-cells: Should be 3. Number of cells being used to specify PWM
> property.
> >> +  First cell specifies the per-chip channel index of the PWM to use,
> >> +the
> >> +  second cell is the period in nanoseconds and bit 0 in the third
> >> +cell is
> >> +  used to encode the polarity of PWM output. Set bit 0 of the third
> >> +in PWM
> >> +  specifier to 1 for inverse polarity & set to 0 for normal polarity.
> >> +- fsl,pwm-clk-ps: the ftm0 pwm clock's prescaler, divide-by 2^n(n = 0
> ~ 7).
> >> +- fsl,pwm-cpwm: Center-Aligned PWM (CPWM) mode.
> >
> > Should describe this in more detail, what does the value actually mean
> for what modes there are?
> 
> Assuming "CPWM" is clearly explained in the HW documentation for this
> chip (I have no idea if that's actually the case), then is it still
> necessary to explain what this means in *detail*? Perhaps simply "see
> section XXX in the TRM" or "see register XXX, bit YYY in the HW
> documentation" would be enough?
>
If to clearly explain the 'CPWM' mode, there maybe need much more words, I think just simply explain it, and then for more detail information "see section XXX in the TRM" or "see register XXX, bit YYY in HW documentation".


Thanks.

--
Best Regards,
Xiubo


