Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbaDDOwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 10:52:21 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61843 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752934AbaDDOwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 10:52:20 -0400
Message-ID: <1396623137.19661.20.camel@x220>
Subject: Re: [PATCH] arm: Fix DEBUG_LL for multi-platform kernels (without
 PL01X)
From: Paul Bolle <pebolle@tiscali.nl>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-kernel@lists.linaro.org,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 04 Apr 2014 16:52:17 +0200
In-Reply-To: <1396620845.19661.14.camel@x220>
References: <1396610269-11580-1-git-send-email-daniel.thompson@linaro.org>
	 <8799740.0uZJLUBGY1@wuerfel> <1396620845.19661.14.camel@x220>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Apr 2014 14:52:17.0964 (UTC) FILETIME=[797A7EC0:01CF5015]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 16:14 +0200, Paul Bolle wrote:
> Correct, see http://thread.gmane.org/gmane.linux.kernel/1646112 . It
> seems nothing happened after that. I'm planning on sending a reminder if
> PLAT_SPEAR_SINGLE is still mentioned in v3.15-rc1.

It turns out my patch was incorrect. This chunk

@@ -95,7 +94,6 @@ config MACH_SPEAR600
     	  Supports ST SPEAr600 boards configured via the device-treesource "arch/arm/mach-spear6xx/Kconfig"
 
 config ARCH_SPEAR_AUTO
-	def_bool PLAT_SPEAR_SINGLE
 	depends on !ARCH_SPEAR13XX && !ARCH_SPEAR6XX
 	select ARCH_SPEAR3XX
 

is bogus. It leaves ARCH_SPEAR_AUTO without a type. So I'll have to
redo, but I'll wait until v3.15-rc1.


Paul Bolle

