Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaI3Nwm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 09:52:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:52105 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaI3Nwk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 09:52:40 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [RFC 1/7] soc: qcom: Add device tree binding for SMEM
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1412037291-16880-2-git-send-email-bjorn.andersson@sonymobile.com>
Date: Tue, 30 Sep 2014 08:52:35 -0500
Cc: Andy Gross <agross@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Suman Anna <s-anna@ti.com>,
        Jeffrey Hugo <jhugo@codeaurora.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <8D91095C-63ED-4988-A4C8-68DADF95FF64@codeaurora.org>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com> <1412037291-16880-2-git-send-email-bjorn.andersson@sonymobile.com>
To: Bjorn Andersson <Bjorn.Andersson@sonymobile.com>
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 29, 2014, at 7:34 PM, Bjorn Andersson <Bjorn.Andersson@sonymobile.com> wrote:

> Add device tree binding documentation for the Qualcom Shared Memory
> manager.
> 
> Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
> ---
> 
> Exposed by this node is a set of items of different sizes. For many things a
> standard of_xlate method of referencing the individual nodes would be
> preferable, so a #something-cells would make sense. We do however also needs
> access to these items without explicitly stating the references in devicetree
> (e.g. SMD references 257 of these). I haven't found any good example of how to
> implement this, so suggestions are welcome.
> 
> Note that the hwspinlock reference is not yet supported in the mainline, but
> this will likely need a few iterations so I wanted to get this out.
> 
> .../devicetree/bindings/soc/qcom/qcom,smem.txt     |   34 ++++++++++++++++++++
> 1 file changed, 34 insertions(+)
> create mode 100644 Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt
> 
> diff --git a/Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt b/Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt
> new file mode 100644
> index 0000000..ddd58c7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/soc/qcom/qcom,smem.txt
> @@ -0,0 +1,34 @@
> +Qualcomm Shared Memory binding
> +
> +This binding describes the Qualcomm Shared Memory, used to share data between
> +various subsystems and OSes in Qualcomm platforms.
> +
> +- compatible:
> +	Usage: required
> +	Value type: <stringlist>
> +	Definition: must be:
> +		    "qcom,smem"
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: base address and size pair for each area representing the
> +		    shared memory. The first pair will must represent the "main"
> +		    area, where the shared memory header and table-of-content
> +		    can be found.
> +
> +- hwspinlocks:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: reference to a hwspinlock used to protect allocations from
> +		    the shared memory
> +
> += EXAMPLE
> +
> +        smem: smem@fa00000 {
> +                compatible = "qcom,smem";
> +                reg = <0x0fa00000 0x200000>,
> +                      <0xfc428000 0x4000>;
> +
> +                hwspinlocks = <&tcsr_mutex 3>;
> +        };
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-arm-msm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

