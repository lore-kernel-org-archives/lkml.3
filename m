Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315Ab3CYHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 03:09:28 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:55036 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3CYHJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 03:09:23 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <thierry.reding@avionic-design.de>, <nsekhar@ti.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <prakash.pm@ti.com>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 2/2] pwm: pwm-tiehrpwm: Update device-tree binding document
References: <1364195093-1357-1-git-send-email-avinashphilip@ti.com>
	<1364195093-1357-3-git-send-email-avinashphilip@ti.com>
Date: Mon, 25 Mar 2013 08:09:17 +0100
In-Reply-To: <1364195093-1357-3-git-send-email-avinashphilip@ti.com> (Philip
	Avinash's message of "Mon, 25 Mar 2013 12:34:53 +0530")
Message-ID: <87ehf4ez1e.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Philip" == Philip Avinash <avinashphilip@ti.com> writes:

 Philip> Update binding document of pwm-tiehrpwm to reflect the usage of similar
 Philip> modules in da850 and am3xx SOCs.

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

 Philip> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
 Philip> Cc: Grant Likely <grant.likely@secretlab.ca>
 Philip> Cc: Rob Herring <rob.herring@calxeda.com>
 Philip> Cc: Rob Landley <rob@landley.net>
 Philip> ---
 Philip>  .../devicetree/bindings/pwm/pwm-tiehrpwm.txt       |   12 ++++++++++--
 Philip>  1 file changed, 10 insertions(+), 2 deletions(-)

 Philip> diff --git a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
 Philip> index 4fc7079..9a71369 100644
 Philip> --- a/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
 Philip> +++ b/Documentation/devicetree/bindings/pwm/pwm-tiehrpwm.txt
 Philip> @@ -1,7 +1,9 @@
 Philip>  TI SOC EHRPWM based PWM controller
 
 Philip>  Required properties:
 Philip> -- compatible : Must be "ti,am33xx-ehrpwm"
 Philip> +- compatible: Must be "ti,<soc>-ehrpwm".
 Philip> +  for am33xx - compatible = "ti,am33xx-ehrpwm";
 Philip> +  for da850  - compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
 Philip>  - #pwm-cells: Should be 3. Number of cells being used to specify PWM property.
 Philip>    First cell specifies the per-chip index of the PWM to use, the second
 Philip>    cell is the period in nanoseconds and bit 0 in the third cell is used to
 Philip> @@ -15,9 +17,15 @@ Optional properties:
 
 Philip>  Example:
 
 Philip> -ehrpwm0: ehrpwm@0 {
 Philip> +ehrpwm0: ehrpwm@0 { /* EHRPWM on am33xx */
 Philip>  	compatible = "ti,am33xx-ehrpwm";
 Philip>  	#pwm-cells = <3>;
 Philip>  	reg = <0x48300200 0x100>;
 Philip>  	ti,hwmods = "ehrpwm0";
 Philip>  };
 Philip> +
 Philip> +ehrpwm0: ehrpwm@0 { /* EHRPWM on da850 */
 Philip> +	compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";
 Philip> +	#pwm-cells = <3>;
 Philip> +	reg = <0x300000 0x2000>;
 Philip> +};
 Philip> -- 
 Philip> 1.7.9.5



-- 
Bye, Peter Korsgaard
