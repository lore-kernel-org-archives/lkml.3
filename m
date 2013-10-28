Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab3J1Gmx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 02:42:53 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59063 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3J1Gmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 02:42:50 -0400
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1382446042-27099-2-git-send-email-sre@debian.org>
Date: Mon, 28 Oct 2013 01:42:47 -0500
Cc: Sebastian Reichel <sre@ring0.de>, linux-input@vger.kernel.org,
        =?iso-8859-1?Q?=27Beno=EEt_Cousson=27?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <5137C017-2515-427C-865F-B938CC24B210@codeaurora.org>
References: <1382446042-27099-1-git-send-email-sre@debian.org> <1382446042-27099-2-git-send-email-sre@debian.org>
To: Sebastian Reichel <sre@debian.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 22, 2013, at 7:47 AM, Sebastian Reichel wrote:

> Add device tree support for twl4030 keypad driver and update the
> Documentation with twl4030 keypad device tree binding information.
> 
> Tested on Nokia N900.
> 
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> ---
> .../devicetree/bindings/input/twl4030-keypad.txt   | 31 ++++++++
> drivers/input/keyboard/twl4030_keypad.c            | 91 ++++++++++++++++++----
> 2 files changed, 105 insertions(+), 17 deletions(-)
> create mode 100644 Documentation/devicetree/bindings/input/twl4030-keypad.txt
> 
> diff --git a/Documentation/devicetree/bindings/input/twl4030-keypad.txt b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
> new file mode 100644
> index 0000000..2b4bd7a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/input/twl4030-keypad.txt
> @@ -0,0 +1,31 @@
> +* TWL4030's Keypad Controller device tree bindings
> +
> +TWL4030's Keypad controller is used to interface a SoC with a matrix-type
> +keypad device. The keypad controller supports multiple row and column lines.
> +A key can be placed at each intersection of a unique row and a unique column.
> +The keypad controller can sense a key-press and key-release and report the
> +event using a interrupt to the cpu.
> +
> +This binding is based on the matrix-keymap binding with the following
> +changes:

Maybe be a bit more specific and say 'based on the input/matrix-keymap.txt binding'..

> +
> + * keypad,num-rows and keypad,num-columns are required.
> +

Is linux,keymap required from matrix-keymap.txt?

> +Required SoC Specific Properties:
> +- compatible: should be one of the following
> +   - "ti,twl4030-keypad": For controllers compatible with twl4030 keypad
> +      controller.
> +- interrupt: should be one of the following
> +   - <1>: For controllers compatible with twl4030 keypad controller.
> +
> +Optional Properties specific to linux:
> +- linux,keypad-no-autorepeat: do no enable autorepeat feature.

Does it make sense to update the matrix-keymap.txt binding to add 'linux,keypad-no-autorepeat' there?

> +
> +Example:
> +	twl_keypad: keypad {
> +		compatible = "ti,twl4030-keypad";
> +		interrupts = <1>;
> +		keypad,num-rows = <8>;
> +		keypad,num-columns = <8>;
> +		linux,keypad-no-autorepeat;
> +	};

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

