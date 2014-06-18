Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933983AbaFRHxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:53:24 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:59962 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756181AbaFRHxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:53:22 -0400
Date: Wed, 18 Jun 2014 08:53:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        Wolfram Sang <wsa@the-dreams.de>, broonie@kernel.org,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/10] mfd: cros_ec: Allow static din/dout buffers with
 cros_ec_register()
Message-ID: <20140618075316.GI21030@lee--X1>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
 <1402954800-28215-4-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402954800-28215-4-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2014, Doug Anderson wrote:

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
> ---
>  include/linux/mfd/cros_ec.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
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

Why don't these use your new format i.e. doutsize, etc?

>   * @command_send: send a command
>   * @command_recv: receive a command
>   * @ec_name: name of EC device (e.g. 'chromeos-ec')

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
