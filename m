Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754831Ab3FGIyZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 04:54:25 -0400
Received: from canardo.mork.no ([148.122.252.1]:45072 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab3FGIyU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 04:54:20 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Adam Lee <adam.lee@canonical.com>
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        ibm-acpi-devel@lists.sourceforge.net,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 1/3] thinkpad_acpi: return -NODEV while operating uninitialized LEDs
Organization: m
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
	<1370593209-21358-2-git-send-email-adam.lee@canonical.com>
Date: Fri, 07 Jun 2013 10:53:50 +0200
In-Reply-To: <1370593209-21358-2-git-send-email-adam.lee@canonical.com> (Adam
	Lee's message of "Fri, 7 Jun 2013 16:20:07 +0800")
Message-ID: <87vc5qxpwh.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adam Lee <adam.lee@canonical.com> writes:

> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -5401,9 +5401,12 @@ static int led_write(char *buf)
>  		return -ENODEV;
>  
>  	while ((cmd = next_cmd(&buf))) {
> -		if (sscanf(cmd, "%d", &led) != 1 || led < 0 || led > 15)
> +		if (sscanf(cmd, "%d", &led) != 1)
>  			return -EINVAL;
>  
> +		if (!tpacpi_leds[led].led)
> +			return -ENODEV;

This looks risky.  Why did you remove the index sanity check?  What will
happen now if the input is e.g "-1" or "42"?

BTW, the magic number 15 should probably be (TPACPI_LED_NUMLEDS - 1)
instead.



Bjørn
