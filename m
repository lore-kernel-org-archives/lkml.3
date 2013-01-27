Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab3A0AgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:36:19 -0500
Received: from mga03.intel.com ([143.182.124.21]:24127 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3A0AgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:36:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,545,1355126400"; 
   d="scan'208";a="195490724"
Date: Sun, 27 Jan 2013 01:36:04 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Axel Lin <axel.lin@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        David Dajun Chen <dchen@diasemi.com>
Subject: Re: [PATCH v1/1] mfd: i2c issue fix for da9052/53
Message-ID: <20130127003604.GH1174@sortiz-mobl>
References: <1359102829.6620.10.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359102829.6620.10.camel@dhruva>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish,

On Fri, Jan 25, 2013 at 02:03:49PM +0530, Ashish Jangam wrote:
> An issue has been reported where the PMIC either locks up or fails to
> respond following a system Reset. This could result in a second write
> in which the bus writes the current content of the write buffer to address
> of the last I2C access.
> 
> The failure case is where this unwanted write transfers incorrect data to
> a critical register.
> 
> This patch fixes this issue to by following any read or write with a dummy read
> to a safe register address. A safe register address is one where the contents
> will not affect the operation of the system.
> 
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> ---
>  drivers/mfd/da9052-i2c.c          |   61 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/da9052/da9052.h |   66 ++++++++++++++++++++++++++++++++++--
>  include/linux/mfd/da9052/reg.h    |    3 ++
>  3 files changed, 126 insertions(+), 4 deletions(-)
Applied to my for-linus branch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
