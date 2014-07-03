Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327AbaGCH2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:28:03 -0400
Received: from mail-ie0-f173.google.com ([209.85.223.173]:57210 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755621AbaGCH2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:28:01 -0400
Date: Thu, 3 Jul 2014 08:27:54 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/10] mfd: cros_ec: Allow static din/dout buffers
 with cros_ec_register()
Message-ID: <20140703072754.GB29114@lee--X1>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403115247-8853-3-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jun 2014, Doug Anderson wrote:

> From: Bill Richardson <wfrichar@chromium.org>
> 
> The lower-level driver may want to provide its own buffers. If so,
> there's no need to allocate new ones.  This already happens to work
> just fine (since we check for size of 0 and use devm allocation), but
> it's good to document it.
> 
> [dianders: Resolved conflicts; documented that no code changes needed
> on mainline]
> 
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>
> ---
> Changes in v2: None
> 
>  include/linux/mfd/cros_ec.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Patch applied.

Clause: There is a chance that this patch might not be seen in -next
for ~24-48hrs.  If it's not there by 72hrs, feel free to poke.

> diff --git a/include/linux/mfd/cros_ec.h b/include/linux/mfd/cros_ec.h
> index 7e9fe6e..2ee3190 100644
> --- a/include/linux/mfd/cros_ec.h
> +++ b/include/linux/mfd/cros_ec.h
> @@ -68,8 +68,8 @@ struct cros_ec_msg {
>   * We use this alignment to keep ARM and x86 happy. Probably word
>   * alignment would be OK, there might be a small performance advantage
>   * to using dword.
> - * @din_size: size of din buffer
> - * @dout_size: size of dout buffer
> + * @din_size: size of din buffer to allocate (zero to use static din)
> + * @dout_size: size of dout buffer to allocate (zero to use static dout)
>   * @command_send: send a command
>   * @command_recv: receive a command
>   * @ec_name: name of EC device (e.g. 'chromeos-ec')

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
