Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbaIXJOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:14:54 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:59162 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059AbaIXJOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:14:48 -0400
Date: Wed, 24 Sep 2014 10:14:41 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Stanimir Varbanov <svarbanov@mm-sol.com>
Cc: Kumar Gala <galak@codeaurora.org>, Stephen Boyd <sboyd@codeaurora.org>,
        David Collins <collinsd@codeaurora.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Grant Likely <grant.likely@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Josh Cartwright <joshc@codeaurora.org>
Subject: Re: [PATCH v4 2/3] mfd: document DT bindings for Qualcomm SPMI PMICs
Message-ID: <20140924091441.GA19999@lee--X1>
References: <1406903450-27283-1-git-send-email-svarbanov@mm-sol.com>
 <1406903450-27283-3-git-send-email-svarbanov@mm-sol.com>
 <53DF8FFA.601@mm-sol.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53DF8FFA.601@mm-sol.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug 2014, Stanimir Varbanov wrote:
> Kumar, Stephen, David can I have your Acked/Reviewed-by tag for 2/3 and
> if possible for 3/3. The last patch can wait because currently we don't
> have child peripherals. Thanks.

No one seems to have an opinion, negative or otherwise.

Applied, thanks.

> On 08/01/2014 05:30 PM, Stanimir Varbanov wrote:
> > Document DT bindings used to describe the Qualcomm SPMI PMICs.
> > 
> > Signed-off-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> > ---
> >  .../devicetree/bindings/mfd/qcom,spmi-pmic.txt     |   64 ++++++++++++++++++++
> >  1 files changed, 64 insertions(+), 0 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> > 
> > diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> > new file mode 100644
> > index 0000000..7182b88
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.txt
> > @@ -0,0 +1,64 @@
> > +          Qualcomm SPMI PMICs multi-function device bindings
> > +
> > +The Qualcomm SPMI series presently includes PM8941, PM8841 and PMA8084
> > +PMICs.  These PMICs use a QPNP scheme through SPMI interface.
> > +QPNP is effectively a partitioning scheme for dividing the SPMI extended
> > +register space up into logical pieces, and set of fixed register
> > +locations/definitions within these regions, with some of these regions
> > +specifically used for interrupt handling.
> > +
> > +The QPNP PMICs are used with the Qualcomm Snapdragon series SoCs, and are
> > +interfaced to the chip via the SPMI (System Power Management Interface) bus.
> > +Support for multiple independent functions are implemented by splitting the
> > +16-bit SPMI slave address space into 256 smaller fixed-size regions, 256 bytes
> > +each. A function can consume one or more of these fixed-size register regions.
> > +
> > +Required properties:
> > +- compatible:      Should contain one of:
> > +                     "qcom,pm8941"
> > +                     "qcom,pm8841"
> > +                     "qcom,pma8084"
> > +                     or generalized "qcom,spmi-pmic".
> > +- reg:             Specifies the SPMI USID slave address for this device.
> > +                   For more information see:
> > +                   Documentation/devicetree/bindings/spmi/spmi.txt
> > +
> > +Required properties for peripheral child nodes:
> > +- compatible:      Should contain "qcom,xxx", where "xxx" is a peripheral name.
> > +
> > +Optional properties for peripheral child nodes:
> > +- interrupts:      Interrupts are specified as a 4-tuple. For more information
> > +                   see:
> > +                   Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt
> > +- interrupt-names: Corresponding interrupt name to the interrupts property
> > +
> > +Each child node of SPMI slave id represents a function of the PMIC. In the
> > +example below the rtc device node represents a peripheral of pm8941
> > +SID = 0. The regulator device node represents a peripheral of pm8941 SID = 1.
> > +
> > +Example:
> > +
> > +	spmi {
> > +		compatible = "qcom,spmi-pmic-arb";
> > +
> > +		pm8941@0 {
> > +			compatible = "qcom,pm8941", "qcom,spmi-pmic";
> > +			reg = <0x0 SPMI_USID>;
> > +
> > +			rtc {
> > +				compatible = "qcom,rtc";
> > +				interrupts = <0x0 0x61 0x1 IRQ_TYPE_EDGE_RISING>;
> > +				interrupt-names = "alarm";
> > +			};
> > +		};
> > +
> > +		pm8941@1 {
> > +			compatible = "qcom,pm8941", "qcom,spmi-pmic";
> > +			reg = <0x1 SPMI_USID>;
> > +
> > +			regulator {
> > +				compatible = "qcom,regulator";
> > +				regulator-name = "8941_boost";
> > +			};
> > +		};
> > +	};
> > 
> 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
