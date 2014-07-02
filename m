Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751359AbaGBHXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 03:23:46 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:35513 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaGBHXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 03:23:44 -0400
Date: Wed, 2 Jul 2014 08:23:38 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Randall Spangler <rspangler@chromium.org>, sjg@chromium.org,
        afaerber@suse.de, stephan@synkhronix.com, olof@lixom.net,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mfd: cros_ec: Use the proper size when looking at
 the cros_ec_i2c result
Message-ID: <20140702072338.GC10311@lee--X1>
References: <1403898973-19571-1-git-send-email-dianders@chromium.org>
 <1403898973-19571-3-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1403898973-19571-3-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jun 2014, Doug Anderson wrote:

> We know how many bytes the EC should be sending us (which is also the
> number of bytes transferred) and also how many bytes the EC actually
> wanted to send to us.  When computing the checksum and copying back
> data let's make sure we take the lesser of the two of those.  We'll
> also complain if the EC tried to send us too many bytes.  The EC
> sending us too few bytes is legit for when we send the EC an invalid
> command.
> 
> This is based on similar code in cros_ec_spi.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mfd/cros_ec_i2c.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Acked-by: Lee Jones <lee.jones@linaro.org>

Is this patch orthogonal i.e. can it be applied without the other two
patches?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
