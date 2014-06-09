Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaFIDt4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2014 23:49:56 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:40157 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbaFIDtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2014 23:49:51 -0400
Date: Mon, 9 Jun 2014 09:19:03 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "kishon@ti.com" <kishon@ti.com>,
        "mathias.nyman@intel.com" <mathias.nyman@intel.com>,
        "jwerner@chromium.org" <jwerner@chromium.org>,
        "kgene.kim@samsung.com" <kgene.kim@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/4] phy: Add provision for calibrating phy.
Message-ID: <20140609034902.GA2625@pratyush-vbox>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
 <1402056736-12674-2-git-send-email-gautam.vivek@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1402056736-12674-2-git-send-email-gautam.vivek@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-08_03:2014-06-06,2014-06-08,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 08:12:12PM +0800, Vivek Gautam wrote:
> Some PHY controllers may need to calibrate certain
> PHY settings after initialization of the controller and
> sometimes even after initializing the PHY-consumer too.
> Add support for the same in order to let consumers do so in need.
> 
> Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
> ---
>  drivers/phy/phy-core.c  |   36 ++++++++++++++++++++++++++++++++++++
>  include/linux/phy/phy.h |    7 +++++++
>  2 files changed, 43 insertions(+)
> 
> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
> index 74d4346..92d31a3 100644
> --- a/drivers/phy/phy-core.c
> +++ b/drivers/phy/phy-core.c
> @@ -376,6 +376,42 @@ int phy_power_off(struct phy *phy)
>  EXPORT_SYMBOL_GPL(phy_power_off);
>  
>  /**
> + * phy_calibrate - calibrate a phy post initialization
> + * @phy: Pointer to 'phy' from consumer
> + *
> + * For certain PHYs, it may be needed to calibrate few phy parameters
> + * post initialization. The need to calibrate may arise after the

For USB you may need to calibrate phy after each new connection. If
so, why not to use already existing struct usb_phy's notify_connect.

        pratyush

