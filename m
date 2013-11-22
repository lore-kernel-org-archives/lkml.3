Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502Ab3KVHTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 02:19:04 -0500
Received: from co9ehsobe005.messaging.microsoft.com ([207.46.163.28]:33900
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750852Ab3KVHS7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 02:18:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 5
X-BigFish: VS5(z551biz1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzz1de098h17326ah8275dh1de097h186068ha509lz2dh109h2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h21a6h2216h22d0hbe9i1155h)
From: Li Xiubo <Li.Xiubo@freescale.com>
To: "thierry.reding@gmail.com" <thierry.reding@gmail.com>
CC: "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "t.figa@samsung.com" <t.figa@samsung.com>,
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
Subject: RE: [PATCHv6 0/4] Add Freescale FTM PWM driver.
Thread-Topic: [PATCHv6 0/4] Add Freescale FTM PWM driver.
Thread-Index: AQHO3032rlefHe0HH0OODOh5ZmXeG5ow4/Dw
Date: Fri, 22 Nov 2013 07:18:54 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F828C7A6E@039-SN2MPN1-012.039d.mgd.msft.net>
References: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1384220218-12716-1-git-send-email-Li.Xiubo@freescale.com>
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

Hi Thierry,

Could you help review this series of patches please ? 

And could it be merged into the PWM next tree?

Thanks very much.

--


> Subject: [PATCHv6 0/4] Add Freescale FTM PWM driver.
> 
> Hello Thierry,
> 
> The series of patches for this version has been reviewed and acked
> already.
> To see each patch for detail.
> 
> 
> ------------------
> ------------------
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
> Changes in v6:
> - Nothing.
> 
> Changes in RFCv2 of PATVHv5:
> - Remove "fsl,pwm-counter-clk".
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pwm" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


