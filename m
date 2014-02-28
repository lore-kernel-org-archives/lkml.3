Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaB1N6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:58:10 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55130 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbaB1N6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:58:08 -0500
Date: Fri, 28 Feb 2014 07:55:27 -0600
From: Josh Cartwright <joshc@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v4 7/9] devicetree: bindings: Document PM8921/8058 keypads
Message-ID: <20140228135527.GF7308@joshc.qualcomm.com>
References: <1393552520-9068-1-git-send-email-sboyd@codeaurora.org>
 <1393552520-9068-8-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393552520-9068-8-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 05:55:18PM -0800, Stephen Boyd wrote:
> Document the keypad device found on PM8921 and PM8058 PMICs.
[..]
> +++ b/Documentation/devicetree/bindings/input/qcom,pm8xxx-keypad.txt
> @@ -0,0 +1,72 @@
> +Qualcomm PM8xxx PMIC Keypad
> +
> +PROPERTIES
> +
> +- compatible:
> +	Usage: required
> +	Value type: <string>
> +	Definition: must be one of:
> +		    "qcom,pm8058-keypad"
> +		    "qcom,pm8921-keypad"
> +- interrupts:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: the first interrupt specifies the key sense interrupt
> +		    and the second interrupt specifies the key stuck interrupt.
> +		    The format of the specifier is defined by the binding
> +		    document describing the node's interrupt parent.
> +
> +- linux,keymap:
> +	Usage: required
> +	Value type: <prop-encoded-array>
> +	Definition: the linux keymap. More information can be found in
> +		    input/matrix-keymap.txt.
> +
> +- keypad,num-rows:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: number of rows in the keymap. More information can be found
> +		    in input/matrix-keymap.txt.
> +
> +- keypad,num-columns:
> +	Usage: required
> +	Value type: <u32>
> +	Definition: number of columns in the keymap. More information can be
> +		    found in input/matrix-keymap.txt.
> +
> +- debounce:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: time in microseconds that key must be pressed or release
> +		    for key sense interrupt to trigger.
> +
> +- scan-delay:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: time in microseconds to pause between successive scans
> +		    of the matrix array.
> +
> +- row-hold:
> +	Usage: optional
> +	Value type: <u32>
> +	Definition: time in nanoseconds to pause between scans of each row in
> +		    the matrix array.

- linux,wakeup?
- linux,no-auto-repeat?

> +
> +EXAMPLE
> +
> +	keypad {
> +		compatible = "qcom,pm8921-keypad";
> +		interrupt-parent = <&pmicintc>;
> +		interrupts = <74 1>, <75 1>;
> +		linux,keymap = <
> +			MATRIX_KEY(0, 0, KEY_VOLUMEUP)
> +			MATRIX_KEY(0, 1, KEY_VOLUMEDOWN)
> +			MATRIX_KEY(0, 2, KEY_CAMERA_FOCUS)
> +			MATRIX_KEY(0, 3, KEY_CAMERA)
> +			>;
> +		keypad,num-rows = <1>;
> +		keypad,num-columns = <5>;
> +		debounce = <15>;
> +		scan-delay = <32>;
> +		row-hold = <91500>;
> +	};

It odd to me that these newly created bindings don't have 'reg'
properties, even though the device clearly has a register region.

I suppose it makes sense from a "port over from platform data to DT"
perspective, as these drivers have just assumed the location of their
registers to be fixed; however I suspect things will need to be changed
if/when we hope to share these drivers with pm8841/pm8941 and beyond...

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
