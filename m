Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbaGISyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:54:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbaGISyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:54:49 -0400
Date: Wed, 9 Jul 2014 11:59:14 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Davide Gianforte <davide@gengisdave.org>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 2/2] staging: silicom: function return fixes
Message-ID: <20140709185914.GA28612@kroah.com>
References: <1972083.WZLDx2N35Z@mayhem>
 <1488578.ritUTSl26I@mayhem>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1488578.ritUTSl26I@mayhem>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 02:33:43PM +0200, Davide Gianforte wrote:
> Function return fixes
> 
> Some functions don't need a temporary variable to store return value.
> 
> Where functions always return 0, changed into void functions.
> 
> Signed-off-by: Davide Gianforte <davide@gengisdave.org>
> --
> 
>  drivers/staging/silicom/bpctl_mod.c | 62 ++++++++++---------------------------
>  1 file changed, 16 insertions(+), 46 deletions(-)
> 
> diff --git a/drivers/staging/silicom/bpctl_mod.c b/drivers/staging/silicom/bpctl_mod.c
> index 1322437..c9a4c40 100644
> --- a/drivers/staging/silicom/bpctl_mod.c
> +++ b/drivers/staging/silicom/bpctl_mod.c
> @@ -117,7 +117,7 @@ static struct bpctl_dev *get_status_port_fn(struct bpctl_dev *pbpctl_dev);
>  static void if_scan_init(void);
>  
>  static int bypass_proc_create_dev_sd(struct bpctl_dev *pbp_device_block);
> -static int bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
> +static void bypass_proc_remove_dev_sd(struct bpctl_dev *pbp_device_block);
>  
>  static int is_bypass_fn(struct bpctl_dev *pbpctl_dev);
>  static int get_dev_idx_bsf(int bus, int slot, int func);
> @@ -1458,9 +1458,8 @@ static int send_wdt_pulse(struct bpctl_dev *pbpctl_dev)
>  static void send_bypass_clear_pulse(struct bpctl_dev *pbpctl_dev,
>  				    unsigned int value)
>  {
> -	uint32_t ctrl_ext = 0;
> +	uint32_t ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);
>  
> -	ctrl_ext = BPCTL_READ_REG(pbpctl_dev, CTRL_EXT);

How about just removing the " = 0;" part of the variable definition?
That would be a smaller patch, and still keep everything "clean".

thanks,

greg k-h
