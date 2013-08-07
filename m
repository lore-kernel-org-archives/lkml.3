Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170Ab3HGU3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 16:29:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52382 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932350Ab3HGU3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 16:29:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Boris BREZILLON <b.brezillon@overkiz.com>
Subject: Re: [PATCH 1/8] ARM: at91: move peripheral id definitions to dt-bindings include dir
Date: Wed, 7 Aug 2013 22:24:30 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <1375339933-3643-1-git-send-email-b.brezillon@overkiz.com>
In-Reply-To: <1375339933-3643-1-git-send-email-b.brezillon@overkiz.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201308072224.30614.arnd@arndb.de>
X-Provags-ID: V02:K0:mGL/4+yTcQSVKfEPq8xaWWhIOYixeV0+GBrlx3EHMqw
 1VDXbNB5nRSae71Y/9NwVssBYnTtML0UWAbnxcuk/iQhy88MEV
 4dBwh1c6V11+AplWFp3RT4xdwv+w4aeI+OCa9qrcAak1eMuGQu
 OmZ/Jh4ONOn1ALKhv2E+MgBqdIDoSJheSothLyQ74KywOpS0AK
 ULch+PqFOpIDkIAjy4ALtMStmo+Bk75ypJM+y6ldpW8yUPu/At
 bkpFiAveCIdUgAcDXIbYrdv4F+4tIpMlmCu3NMM9RNpi3T8+Kw
 kO0yp58ZgXGsEKtM/usZfrVtDGpUhZPvGm+dd0NW6i6W/L2gc3
 ngZguV+nDIcOp15VKUZ0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 August 2013, Boris BREZILLON wrote:
> 
> This patch moves peripheral id definitions from machine specific include
> dir (arch/arm/mach-at91/include/mach/'soc-name'.h) to dt-bindinds include
> dir (include/dt-bindings/at91/'soc-name'/peripherals.h).
> 
> These definitions will be used inside dt to define interrupt ids and
> peripheral clk ids.
> 
> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>

This seems counterproductive, why would you do that?

There is no sharing of identifiers across SoCs here, you just move the
data around, and changing the .dts files to use the abstract macros would
just end up making them harder to understand, not easier, since you then
have to look up the numbers in another file.

	Arnd
