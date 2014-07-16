Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbaGPM3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:29:11 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:61684 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932287AbaGPM3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:29:08 -0400
Message-ID: <53C67000.3090203@linaro.org>
Date: Wed, 16 Jul 2014 13:28:48 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Greg Ungerer <gerg@uclinux.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] arm: ks8695: Migrate debug_ll macros to shared directory
References: <1405506667-4649-1-git-send-email-daniel.thompson@linaro.org> <5177050.SNdzuaeUpQ@wuerfel>
In-Reply-To: <5177050.SNdzuaeUpQ@wuerfel>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/07/14 12:11, Arnd Bergmann wrote:
> On Wednesday 16 July 2014 11:31:07 Daniel Thompson wrote:
>> As part of the migration a couple of uart definitions have been copied
>> from of the platform specific header files.
>>
>> Note that, in order to keep oldconfig working nicely we must defer the
>> removal of arch/arm/mach-ks8695/include/mach/debug-macro.S until
>> DEBUG_LL_UART_NONE has been removed.
>>
>> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Greg Ungerer <gerg@uclinux.org>
>> Cc: Arnd Bergmann <arnd.bergmann@linaro.org>
>> ---
>>
>> Notes:
>>     This is a contribution towards the removal of DEBUG_LL_UART_NONE, see
>>     http://thread.gmane.org/gmane.linux.kernel/1712068/focus=1746065 for
>>     details.
>>
>>  arch/arm/Kconfig.debug          |  8 ++++++++
>>  arch/arm/include/debug/ks8695.S | 40 ++++++++++++++++++++++++++++++++++++++++
>>  2 files changed, 48 insertions(+)
>>  create mode 100644 arch/arm/include/debug/ks8695.S
>>
> The change looks good, but it seems you forgot to remove
> arch/arm/mach-ks8695/include/mach/debug-macro.S.

I explained why I didn't delete this file in the changelog.

If this patch were applied whilst DEBUG_LL_UART_NONE still exists then
there are problems with oldconfig builds failing to compile (for the
same reason as the versatile stuff).


> When you add that, also remember to use 'git format-patch -M' to show the
> changes you did rather than one file added and one removed.

I hope at some point soon(ish) to have a patch series that moves all
four platforms across and trashes DEBUG_LL_UART_NONE. I'll respin this
patch as part of that (with the deleted file).


