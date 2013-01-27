Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab3A0AmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 19:42:04 -0500
Received: from mga09.intel.com ([134.134.136.24]:5926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754866Ab3A0AmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 19:42:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,545,1355126400"; 
   d="scan'208";a="277030789"
Date: Sun, 27 Jan 2013 01:42:00 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        "Kristo, Tero" <t-kristo@ti.com>
Subject: Re: [PATCH 09/19] mfd/twl4030: don't warn about uninitialized return
 code
Message-ID: <20130127004200.GJ1174@sortiz-mobl>
References: <1359123276-15833-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-1-git-send-email-arnd@arndb.de>
 <1359153858-31992-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359153858-31992-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, Jan 25, 2013 at 10:44:08PM +0000, Arnd Bergmann wrote:
> If the twl4030_write_script function gets called with
> a zero length argument, its return value does not
> get set. We know that all scripts have a nonzero
> length, but returning an error in case they ever
> do is probably appropriate.
> 
> Without this patch, building omap2plus_defconfig results in:
> 
> drivers/mfd/twl4030-power.c: In function 'load_twl4030_script':
> drivers/mfd/twl4030-power.c:414:5: error: 'err' may be used uninitialized in this function
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Reviewed-by: Amit Kucheria <amit.kucheria@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: "Kristo, Tero" <t-kristo@ti.com>
> ---
>  drivers/mfd/twl4030-power.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to my for-linus branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
