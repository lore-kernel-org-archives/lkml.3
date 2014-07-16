Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418AbaGPKGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:06:16 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:64146 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbaGPKGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:06:11 -0400
MIME-Version: 1.0
In-Reply-To: <1405465241-28684-2-git-send-email-bjorn.andersson@sonymobile.com>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1405465241-28684-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Wed, 16 Jul 2014 15:36:09 +0530
Message-ID: <CAMf-jS=tkBYQ7mXp71F2_rPo6DE3e4C=sFHqg3Q26a08m6NxJQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] soc: devicetree: bindings: Add Qualcomm RPM DT binding
From: pramod gurav <pramod.gurav.etc@gmail.com>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

RPM breaks on IFC6410 without entry for 'qcom.ipc' node. Please find
my observations below.

On Wed, Jul 16, 2014 at 4:30 AM, Bjorn Andersson
<bjorn.andersson@sonymobile.com> wrote:
> Add binding for the Qualcomm Resource Power Manager (RPM) found in 8660,
> 8960 and 8064 based devices. The binding currently describes the rpm
> itself and the regulator subnodes.
>
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
>  .../devicetree/bindings/soc/qcom/qcom,rpm.txt      | 263 +++++++++++++++++++++
>  include/dt-bindings/soc/qcom,rpm.h                 | 142 +++++++++++
>  2 files changed, 405 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
>  create mode 100644 include/dt-bindings/soc/qcom,rpm.h
>
> diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
> new file mode 100644
> index 0000000..ac98ffc
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/qcom/qcom,rpm.txt
> @@ -0,0 +1,263 @@
> +Qualcomm Resource Power Manager (RPM)
> +
.
[snip]
.

> +- #size-cells:
> +       Usage: required
> +       Value type: <u32>
> +       Definition: must be 0
> +
> +- qcom,ipc:
> +       Usage: required
> +       Value type: <prop-encoded-array>
> +       Definition: three entries specifying:
> +                   - phandle to a syscon node representing the apcs registers
> +                   - u32 representing offset to the register within the syscon
> +                   - u32 representing the ipc bit within the register

Was testing your patch on IFC6410 and looks like its breaking because
this node support not being in IFC DTs. I was using the earlier
versions of these patches and things were working. Please let me know
the changes needed in IFC6410 DT for qcom,ipc.

> +
> +
> += SUBDEVICES
> +

.
[snip]
.

> +       Definition: resource as defined in <dt-bindings/soc/qcom/qcom,rpm.h>
> +
> +
> += EXAMPLE
> +
> +       #include <dt-bindings/soc/qcom,rpm.h>
> +
> +       rpm@108000 {
> +               compatible = "qcom,rpm-msm8960";
> +               reg = <0x108000 0x1000>;
> +               qcom,ipc = <&apcs 0x8 2>;

Tried adding this but there is no reference to 'apcs' registers itself
in any dts.

Without these changes rpm breaks hence not able to test SATA which needs rpm.

> +
> +               interrupts = <0 19 0>, <0 21 0>, <0 22 0>;
> +               interrupt-names = "ack", "err", "wakeup";
> +
.
[snip]
.
> +
> +#endif
> --
> 1.8.2.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Thanks and Regards
Pramod
