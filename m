Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594AbaLJDdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 22:33:14 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:56837 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753789AbaLJDdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 22:33:12 -0500
Date: Tue, 9 Dec 2014 19:33:03 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Dudley Du <dudley.dulixin@gmail.com>
Cc: dmitry.torokhov@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v13 09/12] input: cyapa: add gen5 trackpad device
 firmware update function support
Message-ID: <20141210033303.GA4173@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Dudley Du <dudley.dulixin@gmail.com>, dmitry.torokhov@gmail.com,
	rydberg@euromail.se, bleung@google.com, linux-input@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1418116304-11392-1-git-send-email-dudley.dulixin@gmail.com>
 <1418116304-11392-10-git-send-email-dudley.dulixin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418116304-11392-10-git-send-email-dudley.dulixin@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dudley,

On Tue, Dec 09, 2014 at 05:11:41PM +0800, Dudley Du wrote:
> Add firmware image update function supported for gen5 trackpad device,
> it can be used through sysfs update_fw interface.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudley.dulixin@gmail.com>
> ---
>  drivers/input/mouse/Kconfig      |   2 +-
>  drivers/input/mouse/cyapa_gen5.c | 290 +++++++++++++++++++++++++++++++++++++++
>  2 files changed, 291 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index d8b46b0..63e8b40 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -205,7 +205,7 @@ config MOUSE_BCM5974
>  
>  config MOUSE_CYAPA
>  	tristate "Cypress APA I2C Trackpad support"
> -	depends on I2C
> +	depends on I2C && CRC_ITU_T
>  	help
>  	  This driver adds support for Cypress All Points Addressable (APA)
>  	  I2C Trackpads, including the ones used in 2012 Samsung Chromebooks.
> diff --git a/drivers/input/mouse/cyapa_gen5.c b/drivers/input/mouse/cyapa_gen5.c

My initial config had MOUSE_CYAPA=m and CRC_ITU_T=n.
I did a 'make oldconfig', no questions were asked, but it removed
MOUSE_CYAPA since CRC_ITU_T wasn't enabled.  Since the cyapa modules
were removed the touchpad no longer works.  Not a very good upgrade path :-(
To fix this I have to manually enable MOUSE_CYAPA and CRC_ITU_T to get
it working again.

[...]

-- 
- Jeremiah Mahler
