Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3HFMMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 08:12:31 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42926 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756287Ab3HFMM3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 08:12:29 -0400
Message-ID: <1375791145.12043.47.camel@hornet>
Subject: Re: [RFC 1/2] usb: phy: Add Qualcomm SS-USB and HS-USB drivers for
 DWC3 core
From: Pawel Moll <pawel.moll@arm.com>
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
Cc: "balbi@ti.com" <balbi@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Date: Tue, 06 Aug 2013 13:12:25 +0100
In-Reply-To: <1375789991-30041-2-git-send-email-iivanov@mm-sol.com>
References: <1375789991-30041-1-git-send-email-iivanov@mm-sol.com>
	 <1375789991-30041-2-git-send-email-iivanov@mm-sol.com>
X-Mailer: Evolution 3.8.2-0ubuntu1~raring1
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Aug 2013 12:12:25.0682 (UTC) FILETIME=[367AAB20:01CE929E]
X-MC-Unique: 113080613122601101
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-06 at 12:53 +0100, Ivan T. Ivanov wrote:
> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>

I am sure that the information in the subject is more than enough for
you, but would you care to give some more background for the commit log?
Where can we find such controllers? What is DWC3 core? Is it
Qualcomm-specific block, or does it come from one of the IP providers
like Synopsys or Cadence?

>  .../devicetree/bindings/usb/msm-ssusb.txt          |   49 +++
>  drivers/usb/phy/Kconfig                            |   11 +
>  drivers/usb/phy/Makefile                           |    2 +
>  drivers/usb/phy/phy-msm-dwc3-usb2.c                |  342 +++++++++++++++++
>  drivers/usb/phy/phy-msm-dwc3-usb3.c                |  389 ++++++++++++++++++++
>  5 files changed, 793 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/msm-ssusb.txt
>  create mode 100644 drivers/usb/phy/phy-msm-dwc3-usb2.c
>  create mode 100644 drivers/usb/phy/phy-msm-dwc3-usb3.c
> 
> diff --git a/Documentation/devicetree/bindings/usb/msm-ssusb.txt b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> new file mode 100644
> index 0000000..550b496
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/msm-ssusb.txt
> @@ -0,0 +1,49 @@
> +MSM SuperSpeed USB3.0 SoC controllers

I understand that the device always come in doublets? As in: are nodes
for both USB2 and 3 always required?

> +Required properities :
> +- compatible sould be "qcom,dwc3-usb2";
> +- reg : offset and length of the register set in the memory map
> +- clocks: <&cxo>, <&usb2a_phy_sleep_cxc>;
> +- clock-names: "xo", "sleep_a_clk";
> +<supply-name>-supply: phandle to the regulator device tree node
> +Required "supply-name" examples are:

So required or examples? ;-)

> +       "v1p8" : 1.8v supply for HSPHY
> +       "v3p3" : 3.3v supply for HSPHY
> +       "vbus" : vbus supply for host mode
> +       "vddcx" : vdd supply for HS-PHY digital circuit operation
>
> +Required properities :
> +- compatible sould be "qcom,dwc3-usb3";
> +- reg : offset and length of the register set in the memory map
> +- clocks: <&cxo>, <&usb30_mock_utmi_cxc>;
> +- clock-names: "xo", "ref_clk";
> +<supply-name>-supply: phandle to the regulator device tree node
> +Required "supply-name" examples are:
> +       "v1p8" : 1.8v supply for SS-PHY
> +       "vddcx" : vdd supply for SS-PHY digital circuit operation
> +
> +Example device nodes:
> +
> +       dwc3_usb2: phy@f92f8800 {
> +               compatible = "qcom,dwc3-usb2";
> +               reg = <0xf92f8800 0x30>;
> +
> +               clocks = <&cxo>, <&usb2a_phy_sleep_cxc>;
> +               clock-names = "xo", "sleep_a_clk";
> +
> +               vbus-supply = <&supply>;
> +               vddcx-supply = <&supply>;
> +               v1p8-supply = <&supply>;
> +               v3p3-supply = <&supply>;
> +       };
> +
> +       dwc3_usb3: phy@f92f8830 {
> +               compatible = "qcom,dwc3-usb3";
> +               reg = <0xf92f8830 0x30>;
> +
> +               clocks = <&cxo>, <&usb30_mock_utmi_cxc>;
> +               clock-names = "xo", "ref_clk";
> +
> +               vddcx-supply = <&supply>;
> +               v1p8-supply = <&supply>;
> +       };

Note that I had a look at the bindings only - I don't feel competent to
review the drivers/usb part of the patch...

Thanks!

Pawel



