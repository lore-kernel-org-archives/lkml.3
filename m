Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbaGIJCj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 05:02:39 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:60551 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIJCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 05:02:36 -0400
MIME-Version: 1.0
In-Reply-To: <20140609034902.GA2625@pratyush-vbox>
References: <1402056736-12674-1-git-send-email-gautam.vivek@samsung.com>
	<1402056736-12674-2-git-send-email-gautam.vivek@samsung.com>
	<20140609034902.GA2625@pratyush-vbox>
Date: Wed, 9 Jul 2014 14:32:35 +0530
X-Google-Sender-Auth: NG_8F6eoC5JhQNE6Z44jMs3GNqY
Message-ID: <CAFp+6iH697pP9UWhYLKJc_S2VZUJQ3y6GDzg78gat=X1kybtiQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] phy: Add provision for calibrating phy.
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Pratyush Anand <pratyush.anand@st.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Mon, Jun 9, 2014 at 9:19 AM, Pratyush Anand <pratyush.anand@st.com> wrote:
> On Fri, Jun 06, 2014 at 08:12:12PM +0800, Vivek Gautam wrote:
>> Some PHY controllers may need to calibrate certain
>> PHY settings after initialization of the controller and
>> sometimes even after initializing the PHY-consumer too.
>> Add support for the same in order to let consumers do so in need.
>>
>> Signed-off-by: vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/phy/phy-core.c  |   36 ++++++++++++++++++++++++++++++++++++
>>  include/linux/phy/phy.h |    7 +++++++
>>  2 files changed, 43 insertions(+)
>>
>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>> index 74d4346..92d31a3 100644
>> --- a/drivers/phy/phy-core.c
>> +++ b/drivers/phy/phy-core.c
>> @@ -376,6 +376,42 @@ int phy_power_off(struct phy *phy)
>>  EXPORT_SYMBOL_GPL(phy_power_off);
>>
>>  /**
>> + * phy_calibrate - calibrate a phy post initialization
>> + * @phy: Pointer to 'phy' from consumer
>> + *
>> + * For certain PHYs, it may be needed to calibrate few phy parameters
>> + * post initialization. The need to calibrate may arise after the
>
> For USB you may need to calibrate phy after each new connection. If
> so, why not to use already existing struct usb_phy's notify_connect.

The phy_calibrate will rather be a one time phenomenon.
On exynos atleast the case is : the phy settings for PIPE3 phy on DWC3
controller need to be
configured post hcd reset. so that we don't need to re-configure these
phy settings on every connect.

Moreover *there are certain devices* which need these PHY settings
even to show a connect-status-change.
So, it would rather be not useful to create a 'phy_notify_connect' API
in drivers/phy/ and use the same for this purpose.



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
