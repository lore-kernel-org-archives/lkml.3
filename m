Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3HWS2m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 14:28:42 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40261 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754760Ab3HWS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 14:28:38 -0400
X-Sasl-enc: RUGhJFCX+ISAiEiTjc+vu+EM8ub1W2vAjQQUVHsxtbpj 1377281804
Date: Fri, 23 Aug 2013 15:16:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: linux-acpi@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com, rjw@sisk.pl,
        len.brown@intel.com, dtor@insightbb.com
Subject: Re: [PATCH 2/3] thinkpad_acpi: Support micmute LED
Message-ID: <20130823181642.GA27893@khazad-dum.debian.net>
References: <1377180132-4933-1-git-send-email-Jason@zx2c4.com>
 <1377180132-4933-2-git-send-email-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377180132-4933-2-git-send-email-Jason@zx2c4.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason!

On Thu, 22 Aug 2013, Jason A. Donenfeld wrote:

> The micmute LED is currently unused. This patch allows it to be hooked
> up to various LED triggers.
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  drivers/platform/x86/thinkpad_acpi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index 54d31c0..33b23cb 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -5050,8 +5050,10 @@ static const char * const tpacpi_led_names[TPACPI_LED_NUMLEDS] = {
>  	"tpacpi::unknown_led2",
>  	"tpacpi::unknown_led3",
>  	"tpacpi::thinkvantage",
> +	"tpacpi::unknown_led4",
> +	"tpacpi::micmute"
>  };
> -#define TPACPI_SAFE_LEDS	0x1081U
> +#define TPACPI_SAFE_LEDS	0x5081U

Micmute is not a "safe" LED by thinkpad-acpi's definition.

Besides, I want to see that LED hooked to alsa, any other use should be
protected by a module parameter (like fan-control is) or kernel config (like
unsafe LEDs are).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
