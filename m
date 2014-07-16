Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139AbaGPLLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:11:13 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55792 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaGPLLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:11:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] arm: ks8695: Migrate debug_ll macros to shared directory
Date: Wed, 16 Jul 2014 13:11:07 +0200
Message-ID: <5177050.SNdzuaeUpQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405506667-4649-1-git-send-email-daniel.thompson@linaro.org>
References: <1405506667-4649-1-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:rVLLCjOq2kppxhmhK7b96V9z9itJNjw/G0sfdRiNyz0
 3876uTjgG7znv+DDW7v4LI5d47I6qZqRdqlX3vZ4e8SZ1oirAb
 SWlajtrGb3o+bMf2cgZ07BqavFk46TE5s4odt4ASKj3XyhiLHj
 9hsGOEsOie7Va9UiHWvbHNW5a9KWS50RmKnD/S5H6CV06m0hCd
 GmdKwdWEl7a5eWg+MuXvj5qAeQ5OD7fONIL2M8r745M3hobn/P
 FGTdErV1D6dSIORg8y/l6/QxWwz66HGr3lhXncqyZiBeQrCwDh
 jQ3u45HhkDamfK7HWxe+fbnC3bF40ZJG8xhrg/GU5t4QejfVVQ
 qYUWufNEoZfGtgZxbGhw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 11:31:07 Daniel Thompson wrote:
> As part of the migration a couple of uart definitions have been copied
> from of the platform specific header files.
> 
> Note that, in order to keep oldconfig working nicely we must defer the
> removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
> DEBUG_LL_UART_NONE has been removed.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
> ---
> 
> Notes:
>     This is a contribution towards the removal of DEBUG_LL_UART_NONE, see
>     http://thread.gmane.org/gmane.linux.kernel/1712068/focus=1746065 for
>     details.
> 
>  arch/arm/Kconfig.debug          |  8 ++++++++
>  arch/arm/include/debug/ks8695.S | 40 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 48 insertions(+)
>  create mode 100644 arch/arm/include/debug/ks8695.S
> 
The change looks good, but it seems you forgot to remove
arch/arm/mach-ks8695/include/mach/debug-macro.S.

When you add that, also remember to use 'git format-patch -M' to show the
changes you did rather than one file added and one removed.

	Arnd
