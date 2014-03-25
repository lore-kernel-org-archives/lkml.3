Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaCYIiz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 04:38:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:55419 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830AbaCYIir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 04:38:47 -0400
Date: Tue, 25 Mar 2014 10:38:37 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Surendra Patil <surendra.tux@gmail.com>
Cc: marcel@holtmann.org, gustavo@padovan.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:bluetooth:ath3k.c: Fixed sparse warning for cast
 to restricted __le32
Message-ID: <20140325083837.GB5490@t440s.lan>
Mail-Followup-To: Surendra Patil <surendra.tux@gmail.com>,
	marcel@holtmann.org, gustavo@padovan.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1395735950-17968-1-git-send-email-surendra.tux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395735950-17968-1-git-send-email-surendra.tux@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Mar 25, 2014, Surendra Patil wrote:
> This patch fixes below Sparse warnings -
> drivers/bluetooth/ath3k.c:370:17: warning: cast to restricted __le32
> drivers/bluetooth/ath3k.c:432:17: warning: cast to restricted __le32
> 
> Signed-off-by: Surendra Patil <surendra.tux@gmail.com>
> ---
>  drivers/bluetooth/ath3k.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/bluetooth/ath3k.c b/drivers/bluetooth/ath3k.c
> index be571fe..badacbc 100644
> --- a/drivers/bluetooth/ath3k.c
> +++ b/drivers/bluetooth/ath3k.c
> @@ -367,7 +367,7 @@ static int ath3k_load_patch(struct usb_device *udev)
>  	}
>  
>  	snprintf(filename, ATH3K_NAME_LEN, "ar3k/AthrBT_0x%08x.dfu",
> -		le32_to_cpu(fw_version.rom_version));
> +		fw_version.rom_version);
>  
>  	ret = request_firmware(&firmware, filename, &udev->dev);
>  	if (ret < 0) {
> @@ -429,7 +429,7 @@ static int ath3k_load_syscfg(struct usb_device *udev)
>  	}
>  
>  	snprintf(filename, ATH3K_NAME_LEN, "ar3k/ramps_0x%08x_%d%s",
> -		le32_to_cpu(fw_version.rom_version), clk_value, ".dfu");
> +		 fw_version.rom_version, clk_value, ".dfu");
>  
>  	ret = request_firmware(&firmware, filename, &udev->dev);
>  	if (ret < 0) {

Are you sure this doesn't introduce a bug on big endian systems? We just
recently applied commit b9e2535acad8f52a17e2aa843d45a6b756b59592 which
adds this le32_to_cpu conversion. Probably the correct fix is to update
this fw_version struct definition to use __le32 for any member that's
expected to be in little endian format?

Johan
