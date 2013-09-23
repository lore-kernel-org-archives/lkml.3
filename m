Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3IWVnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 17:43:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39785 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753582Ab3IWVnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 17:43:33 -0400
Message-ID: <5240B5FF.6060901@wwwdotorg.org>
Date: Mon, 23 Sep 2013 15:43:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
CC: lee.jones@linaro.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, rob@landley.net, broonie@kernel.org,
        patches@opensource.wolfsonmicro.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mfd: arizona: Add device tree bindings for MICBIAS
 generators
References: <1379961043-23762-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1379961043-23762-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
In-Reply-To: <1379961043-23762-5-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2013 12:30 PM, Charles Keepax wrote:
> Add device tree bindings for the pdata needed to configure the MICBIAS
> generators.

> diff --git a/Documentation/devicetree/bindings/mfd/arizona.txt b/Documentation/devicetree/bindings/mfd/arizona.txt

> +  - wlf,micbias1 : Configuration for the micbias regulator, should include 5
> +    cells.
> +    The first cell is the output voltage in millivolts
> +    The second cell a non-zero value indicates an external capacitor is fitted

I think you need some kind of delimiter (e.g. a colon) after "cell"
there, to separate the line's label and description.

> +    The four cell a non-zero value indicates that the micbias should be

s/four/fourth/

There are lots of cells here with a single-bit flag in them. Can the
flags be combined into a single cell to reduce the DT size? cpp-based
named constants should keep the *.dts file readable.
