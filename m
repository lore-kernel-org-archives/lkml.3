Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675AbaFRHpk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:45:40 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:49260 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158AbaFRHpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:45:39 -0400
Date: Wed, 18 Jun 2014 08:45:32 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/10] mfd: cros_ec: Use struct cros_ec_command to
 communicate with the EC
Message-ID: <20140618074532.GF21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-7-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402954800-28215-7-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> This is some internal structure reorganization / renaming to prepare
> for future patches that will add a userspace API to cros_ec.  There
> should be no visible changes.
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mfd/cros_ec.c       | 28 ++++++++++++++--------------
>  drivers/mfd/cros_ec_i2c.c   | 24 ++++++++++++------------
>  drivers/mfd/cros_ec_spi.c   | 16 ++++++++--------
>  include/linux/mfd/cros_ec.h | 35 ++++++++++++++++++-----------------
>  4 files changed, 52 insertions(+), 51 deletions(-)
>   */
> -struct cros_ec_msg {
> -	u8 version;
> -	u8 cmd;
> -	uint8_t *out_buf;
> -	int out_len;
> -	uint8_t *in_buf;
> -	int in_len;
> +struct cros_ec_command {
> +	uint32_t version;
> +	uint32_t command;
> +	uint8_t *outdata;
> +	uint32_t outsize;
> +	uint8_t *indata;
> +	uint32_t insize;
> +	uint32_t result;

If you're sure these type changed do not cause you any bother:
  Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
