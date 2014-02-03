Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaBCPGY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:06:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:51205 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaBCPGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:06:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/10] watchdog: xilinx: Add missing binding
Date: Mon, 3 Feb 2014 16:06:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        monstr@monstr.eu, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-doc@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>
References: <ed4cb31c9a549343e6b492cf62fc962d39034bd0.1391177880.git.michal.simek@xilinx.com> <9c721b89ed2ceb6997809bb3363f852277e67dc2.1391177880.git.michal.simek@xilinx.com>
In-Reply-To: <9c721b89ed2ceb6997809bb3363f852277e67dc2.1391177880.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402031606.11753.arnd@arndb.de>
X-Provags-ID: V02:K0:4XcI+FIrqKwLliqnLQYrHYzQIreHmXWSeY/85w53wFa
 cFEdmlyCbLlr2rjk38blzY6Ny6P2VNRgASz0Gwde6UzbLYkkul
 FgwXrf7sFmQDSYa19FWjVoJqr3NRWKtparmjep7K9b/oRWtOm5
 J1XTwOxXC+qHt48E6u1X6JV0/4bfG8pt8deJro2yyPfyTfWjA6
 EFYQP21dHibADLDeAL2FeQXIJGmt9Iyfmeor7BJMwpA0nzrpJY
 ZQ8pPL9Pg0IRe1bDgTe/v6Wrbm4REtQeCkNKsDaF5QS42wja1g
 5ntpewxYkR8L1Q/Od1C6VvURebt1I9uV2T79h08t8xn3tWM4Kp
 HaL5RueKOb9oGobJaTmLk4ILdVQn13zRAdA7ux1+Z
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 January 2014, Michal Simek wrote:
> +Optional properties:
> +- clock-frequency      : Frequency of clock in Hz
> +- xlnx,wdt-enable-once : 0 - Watchdog can be restarted
> +                         1 - Watchdog can be enabled just once
> +- xlnx,wdt-interval    : Watchdog timeout interval in 2^<val> clock cycles,
> +                         <val> is integer from 8 to 31.
> +

The latter two don't really seem to be xilinx specific, it would be
reasonable to have a standard watchdog binding that mandates a common
format for them.

I'm not sure about the enable-once flag, which seems to just map to the
"nowayout" watchdog option that is not a hardware feature at all
and should probably be kept as a software setting only, rather than
settable through DT. If it is kept, it should have a standard name and
get turned into a boolean (present/absent) property rather than a
0/1 integer property.

The interval should really be specified in terms of seconds or miliseconds,
not in clock cycles.

	Arnd
