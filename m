Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab3DWJGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 05:06:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:8616 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab3DWJGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 05:06:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,531,1363158000"; 
   d="scan'208";a="299579047"
Message-ID: <1366708088.9823.16.camel@sauron.fi.intel.com>
Subject: eGalax touchscreen regression
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Hui Wang <jason77.wang@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Zhang Jiejing <jiejing.zhang@freescale.com>,
        Hui Wang <jason77.wang@gmail.com>, linux-input@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Hofemeier, Ulf" <ulf.hofemeier@intel.com>
Date: Tue, 23 Apr 2013 12:08:08 +0300
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

in the below commit

commit ae495e844a77344fdaedbb2ad97d925d096e9f0d
Author: Hui Wang <jason77.wang@gmail.com>
Date:   Thu Oct 25 00:38:01 2012 -0700

    Input: egalax_ts - get gpio from devicetree
    
    The irq_to_gpio() is old, most platforms use GENERIC_GPIO framework
    and don't support this API anymore.
    
    The i.MX6q sabrelite platform equips an egalax touchscreen controller,
    and this platform already transfered to GENERIC_GPIO framework, to
    support this driver, we use a more generic way to get gpio.
    
    Add a return value checking for waking up the controller in the probe
    function, this guarantee only a workable device can pass init.
    
    [dmitry.torokhov@gmail.com: Make driver depend on CONFIG_OF as it is
     now required.]
    
    Acked-by Zhang Jiejing <jiejing.zhang@freescale.com>
    Reviewed-by: Shawn Guo <shawn.guo@linaro.org>
    Signed-off-by: Hui Wang <jason77.wang@gmail.com>
    Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

the eGalax driver now requires OF. For us this is a regression because
we do not have OF: https://bugs.tizen.org/jira/browse/TIVI-740

-- 
Best Regards,
Artem Bityutskiy

