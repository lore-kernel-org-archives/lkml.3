Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab3KULCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:02:24 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:64548 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3KULCS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:02:18 -0500
Date: Thu, 21 Nov 2013 11:02:11 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH -v2 09/10] mfd: staging: Constify struct mfd_cell where
 possible
Message-ID: <20131121110211.GB23067@lee--X1>
References: <1384781586-4798-1-git-send-email-geert@linux-m68k.org>
 <1384781586-4798-9-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384781586-4798-9-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Nov 2013, Geert Uytterhoeven wrote:

> As of commit 03e361b25ee8dfb1fd9b890072c23c4aae01c6c7 ("mfd: Stop setting
> refcounting pointers in original mfd_cell arrays"), the "cell" parameter of
> mfd_add_devices() is "const" again. Hence make all cell data passed to
> mfd_add_devices() const where possible.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: devel@driverdev.osuosl.org
> ---
> v2: Split in groups
> 
>  drivers/staging/nvec/nvec.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

It looks like I need Greg's Ack on this before I apply it.

> diff --git a/drivers/staging/nvec/nvec.c b/drivers/staging/nvec/nvec.c
> index 3066ee2e753b..27d74134f187 100644
> --- a/drivers/staging/nvec/nvec.c
> +++ b/drivers/staging/nvec/nvec.c
> @@ -83,7 +83,7 @@ enum nvec_sleep_subcmds {
>  
>  static struct nvec_chip *nvec_power_handle;
>  
> -static struct mfd_cell nvec_devices[] = {
> +static const struct mfd_cell nvec_devices[] = {
>  	{
>  		.name = "nvec-kbd",
>  		.id = 1,

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
