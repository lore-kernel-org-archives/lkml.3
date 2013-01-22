Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab3AVD1P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 22:27:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:60774 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755623Ab3AVD1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 22:27:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,511,1355126400"; 
   d="scan'208";a="274986041"
Date: Tue, 22 Jan 2013 04:27:08 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Aaron Sierra <asierra@xes-inc.com>
Cc: =?iso-8859-1?B?QWfzY3MgUOFs?= <agocs.pal.86@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH v2] lpc_ich: fix gpio base and control offsets
Message-ID: <20130122032708.GO7409@sortiz-mobl>
References: <88cea640-8f88-4fd4-9cb0-77ed482d7e19@zimbra>
 <63f2f7f3-fd03-433e-8990-d60d38954e7b@zimbra>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <63f2f7f3-fd03-433e-8990-d60d38954e7b@zimbra>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Aaron,

On Tue, Jan 15, 2013 at 02:42:45PM -0600, Aaron Sierra wrote:
> In ICH5 and earlier the GPIOBASE and GPIOCTRL registers are found at
> offsets 0x58 and 0x5C, respectively. This patch allows GPIO access to
> properly be enabled (and disabled) for these chipsets.
> 
> Signed-off-by: Agócs Pál <agocs.pal.86@gmail.com>
> Signed-off-by: Aaron Sierra <asierra@xes-inc.com>
> ---
>  drivers/mfd/lpc_ich.c |   40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
I'm fine with the gpio base and offset fixes, but the
s/id->driver_data/lpc_ich_chipset/ changes are not very nice.
It's probably time to introduce an lpc_ich_prv struct that would contain the
device id and also the 2 acpi_save and gpio_save static variable. You allocate
it in your probe routine and hook it to your pci_dev pointer through
pci_set_drvdata().
pci_get_drvdata() will help you fetch that structure back from your pci_dev
pointer. The driver will overall look cleaner this way.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
