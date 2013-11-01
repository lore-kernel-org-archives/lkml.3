Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab3KAGeI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 02:34:08 -0400
Received: from co9ehsobe004.messaging.microsoft.com ([207.46.163.27]:37142
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751951Ab3KAGeF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 02:34:05 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551biz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275dh1de097h186068hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216hbe9i1155h)
From: Li Xiubo <B47053@freescale.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "rob@landley.net" <rob@landley.net>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [RFCv2][PATCHv5 0/4] Add Freescale FTM PWM driver.
Thread-Topic: [RFCv2][PATCHv5 0/4] Add Freescale FTM PWM driver.
Thread-Index: AQHO1T6krylUwjAGikee2OoD5TyfU5oP6xVA
Date: Fri, 1 Nov 2013 06:34:00 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F82871744@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1383114204-17264-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1383114204-17264-1-git-send-email-Li.Xiubo@freescale.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.78]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Therry,

The binding patch has been acked, how about the other patches ?

If they are all okey, should I sent a another official version again ?


Thanks.


--
Xiubo



> Subject: [RFCv2][PATCHv5 0/4] Add Freescale FTM PWM driver.
> 
> Hello,
> 
> This patch series is the Freescale FTM PWM implementation. And there are
> 8 channels most supported by the FTM PWM. This implementation is only
> compatible with device tree definition.
> 
> This patch series is based on linux-next and has been tested on Vybrid
> VF610 Tower board using device tree.
> 
> 
> 
> Changes in RFCv2 of PATVHv5:
> - Remove "fsl,pwm-counter-clk"(all the four patches are modified).
> 
> Changes in v5:
> - Remove active/idle pinctrl stuff.
> 
> Changes in v4:
> - Check for the result and return an error for devm_kzalloc().
> - Move pinmux setting from the SoC file to the board specific file.
> - Revise the written mistake of 'ret |= FTMSC_CLKEXT;' --> 'reg |=
> FTMSC_CLKEXT;'.
> 
> 
> Changes in v3:
> - Remove "availabe" field.
> - Remove "fsl,pwm-avaliable-chs" property.
> - ...
> 
> Changes in v2:
> - Remove PWM CPWM/EPWM feature and sysfs.
> - Remove some redundant code.
> - Revise some code for more readable.
> - Remove "fsl,pwm-clk-ps", "fsl,pwm-number", "fsl,pwm-channels",etc.
> - Add "fsl,pwm-avaliable-chs", "fsl,pwm-counter-clk", etc.
> - Support 8 channels default in dtsi file.
> - Add counter clock source selection.
> - Rename some function name, macro name, etc.
> - Use PWM's and OF's existing function interfaces.
> - Split clk_unprepare_enable to clk_unprepare and clk_enable,etc.
> - ...
> 
> Added in v1:
> - Add Freescale FTM PWM driver support.
> - Add Freescale FTM PWM node for VF610.
> - Enable Enables FTM PWM device for Vybrid VF610 TOWER.
> - Add device tree bindings for Freescale.
> 
> 
> 
> 
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


