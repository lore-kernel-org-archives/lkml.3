Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964878Ab3CNPtZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:49:25 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60069 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964813Ab3CNPtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:49:10 -0400
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Philip Avinash <avinashphilip@ti.com>
Cc: <nsekhar@ti.com>, <linux@arm.linux.org.uk>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        prakash.pm@ti.com
Subject: Re: [PATCH 3/3] ARM: davinci: da850: add EHRPWM & ECAP DT node
References: <1363257453-24747-1-git-send-email-avinashphilip@ti.com>
	<1363257453-24747-4-git-send-email-avinashphilip@ti.com>
Date: Thu, 14 Mar 2013 16:49:06 +0100
In-Reply-To: <1363257453-24747-4-git-send-email-avinashphilip@ti.com> (Philip
	Avinash's message of "Thu, 14 Mar 2013 16:07:33 +0530")
Message-ID: <87mwu656dp.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "P" == Philip Avinash <avinashphilip@ti.com> writes:

 P> Add da850 EHRPWM & ECAP DT node.
 P> Also adds OF_DEV_AUXDATA for EHRPWM & ECAP driver to use EHRPWM & ECAP
 P> clock.

 P> Signed-off-by: Philip Avinash <avinashphilip@ti.com>
 P> ---
 P> :100644 100644 3ec1bda... 9b5b613... M	arch/arm/boot/dts/da850.dtsi
 P> :100644 100644 72466ab... e32484c... M	arch/arm/mach-davinci/da8xx-dt.c
 P>  arch/arm/boot/dts/da850.dtsi     |   30 ++++++++++++++++++++++++++++++
 P>  arch/arm/mach-davinci/da8xx-dt.c |    5 +++++
 P>  2 files changed, 35 insertions(+)

 P> diff --git a/arch/arm/boot/dts/da850.dtsi b/arch/arm/boot/dts/da850.dtsi
 P> index 3ec1bda..9b5b613 100644
 P> --- a/arch/arm/boot/dts/da850.dtsi
 P> +++ b/arch/arm/boot/dts/da850.dtsi
 P> @@ -107,6 +107,36 @@
 P>  			reg = <0x21000 0x1000>;
 P>  			status = "disabled";
 P>  		};
 P> +		ehrpwm0: ehrpwm@01f00000 {
 P> +			compatible = "ti,da850-ehrpwm";

This should be:

compatible = "ti,da850-ehrpwm", "ti,am33xx-ehrpwm";

 P> +		ecap0: ecap@01f06000 {
 P> +			compatible = "ti,da850-ecap";

And:

compatible = "ti,da850-ecap", "ti,am33xx-ecap";

-- 
Bye, Peter Korsgaard
