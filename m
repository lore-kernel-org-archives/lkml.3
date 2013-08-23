Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab3HWV4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:56:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40106 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab3HWV4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:56:01 -0400
Message-ID: <5217DA6C.4060903@wwwdotorg.org>
Date: Fri, 23 Aug 2013 15:55:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Josh Cartwright <joshc@codeaurora.org>
CC: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kumar Gala <galak@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH RFC v2 5/5] spmi: document the PMIC arbiter SPMI bindings
References: <cover.1377202730.git.joshc@codeaurora.org> <ea2d30d47cb54b4322231f5c319663ee9c996784.1377202730.git.joshc@codeaurora.org>
In-Reply-To: <ea2d30d47cb54b4322231f5c319663ee9c996784.1377202730.git.joshc@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 02:37 PM, Josh Cartwright wrote:

Patch description?

> diff --git a/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt b/Documentation/devicetree/bindings/spmi/qcom,spmi-pmic-arb.txt

> +Required properties:
> +- compatible : should be "qcom,spmi-pmic-arb".
> +- reg-names  : should be "core", "intr", "cnfg"

> +- reg : offset and length of the PMIC Arbiter Core register map.
> +- reg : offset and length of the PMIC Arbiter Interrupt controller register map.
> +- reg : offset and length of the PMIC Arbiter Configuration register map.

This seems like it's defining the "reg" property 3 times each with a
different meaning. It'd be better to say something like:

reg : register specifier. Must contain 3 entries, in the following
order: core registers, interrupt register, configuration registers.

> +	qcom,spmi@fc4c0000 {
...
> +		qcom,pm8841@4 {

Node names typically don't include a vendor prefix. For the first
instance above, I think just "spmi@fc4c0000" or even just "spmi" would
be appropriate here; the latter being best in the case where there's
only 1 SPMI controller and hence no need to include the unit address for
uniqueness.

