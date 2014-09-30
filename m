Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaI3TDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 15:03:32 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:55980 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaI3TD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 15:03:29 -0400
Message-ID: <542AFE79.6030304@codeaurora.org>
Date: Tue, 30 Sep 2014 12:03:21 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Rob Herring <robh+dt@kernel.org>
CC: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Suman Anna <s-anna@ti.com>
Subject: Re: [RFC 1/7] soc: qcom: Add device tree binding for SMEM
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com> <1412037291-16880-2-git-send-email-bjorn.andersson@sonymobile.com>
In-Reply-To: <1412037291-16880-2-git-send-email-bjorn.andersson@sonymobile.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/14 17:34, Bjorn Andersson wrote:
> +
> +- reg:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: base address and size pair for each area representing the
> +		    shared memory. The first pair will must represent the "main"
> +		    area, where the shared memory header and table-of-content
> +		    can be found.
>
> +
> += EXAMPLE
> +
> +        smem: smem@fa00000 {
> +                compatible = "qcom,smem";
> +                reg = <0x0fa00000 0x200000>,
> +                      <0xfc428000 0x4000>;

Isn't this second entry rpm message ram? That isn't the same as smem.
Plus smem is part of ram (and rpm message ram is not) so we need to do
memory reservations or something.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

