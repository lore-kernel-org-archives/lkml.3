Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab3EQI2k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 04:28:40 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:50338 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab3EQI2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 04:28:38 -0400
Message-ID: <5195EA34.7000409@prisktech.co.nz>
Date: Fri, 17 May 2013 20:28:36 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Bergmann, Arnd" <arnd@arndb.de>, "Johansson, Olof" <olof@lixom.net>
Subject: Re: [PATCH] ARM: vt8500: Add missing NULL terminator in dt_compat
References: <1368776657-23035-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1368776657-23035-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/13 19:44, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> When I tried booting a stih415 Dual core A9 with multi_v7_defconfig, it
> failed to boot. The issues seems to be changing by enabling or disabling
> VT8550 platform. Having a quick look at dt_compat list, it seems to miss
> a NULL terminator, which means of_flat_dt_match will compat check will
> cross the boundary of dt_compat and fault at some point , which is what
> was happening in my case.
>
> Without this patch if we try to boot multi_v7_defconfig you might notice
> that some of the platforms might fault if they fall after vt8500 in
> machine-desc list. Other platforms which fall before vt8500 in mdesc list
> will not fault.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> ---
>   arch/arm/mach-vt8500/vt8500.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/arch/arm/mach-vt8500/vt8500.c b/arch/arm/mach-vt8500/vt8500.c
> index 1dd281e..f5c33df 100644
> --- a/arch/arm/mach-vt8500/vt8500.c
> +++ b/arch/arm/mach-vt8500/vt8500.c
> @@ -173,6 +173,7 @@ static const char * const vt8500_dt_compat[] = {
>   	"wm,wm8505",
>   	"wm,wm8750",
>   	"wm,wm8850",
> +	NULL
>   };
>   
>   DT_MACHINE_START(WMT_DT, "VIA/Wondermedia SoC (Device Tree Support)")
My bad. Thanks for the fix.

Acked-by: Tony Prisk <linux@prisktech.co.nz>

Arnd, Olof: Can you apply this directly please.

Regards
Tony Prisk
