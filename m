Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902Ab3IWUkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:40:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50185 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3IWUkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:40:37 -0400
Message-ID: <5240A740.7000407@wwwdotorg.org>
Date: Mon, 23 Sep 2013 14:40:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: linux-media@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] media: st-rc: Add ST remote control driver
References: <1379581176-25078-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1379581176-25078-1-git-send-email-srinivas.kandagatla@st.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 02:59 AM, Srinivas KANDAGATLA wrote:
> This patch adds support to ST RC driver, which is basically a IR/UHF
> receiver and transmitter. This IP (IRB) is common across all the ST
> parts for settop box platforms. IRB is embedded in ST COMMS IP block.
> It supports both Rx & Tx functionality.
> 
> In this driver adds only Rx functionality via LIRC codec.

> diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/media/st-rc.txt

> +Required properties:
> +	- compatible: should contain "st,comms-irb".
> +	- reg: base physical address of the controller and length of memory
> +	mapped  region.

Nits:

The indentation is a little odd here; I'd expect the - to be in column
1, at least that's how most other binding docs are written. Not a big
deal though.

It'd be nice to indent the continuation lines (e.g. "mapped region") a
bit more so it's easier to see where each new entry starts.

There are two spaces in "mapped  region".

> +	- rx-mode: can be "infrared" or "uhf". rx-mode should be present iff the
> +	  rx pins are wired up.
> +	- tx-mode: should be "infrared". tx-mode should be present iff the tx
> +	  pins are wired up.

Should those property names be prefixed with "st,"; I assume they're
specific to this binding rather than something generic that applies to
all IR controller bindings? If you expect them to be generic, it's fine.

> +	- clocks : phandle with clock-specifier pair.

For what clock?
