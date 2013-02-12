Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab3BLKfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:35:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:35675 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756263Ab3BLKe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:34:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,648,1355126400"; 
   d="scan'208";a="284622509"
Date: Tue, 12 Feb 2013 11:34:55 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Darren Hart <dvhart@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] lpc_sch: Accomodate partial population of the MFD devices
Message-ID: <20130212103455.GG20996@sortiz-mobl>
References: <b2f78b0d872215533102ec6b9ef8cf42c8f75705.1360365636.git.dvhart@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b2f78b0d872215533102ec6b9ef8cf42c8f75705.1360365636.git.dvhart@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Darren,

On Fri, Feb 08, 2013 at 03:20:36PM -0800, Darren Hart wrote:
> The current probe aborts if any of the 3 base address registers are
> disabled. On a TunnelCreek system I am working on, this resulted in the
> SMBIOS and GPIO devices being removed when it couldn't read the base
> address for the watchdog timer.
> 
> This patch accommodates partial population of the lpc_sch_cells array and
> only aborts if all the base address registers are disabled. A max size
> array is allocated and the individual device cells are added to it after
> their base addresses are successfully determined. This simplifies the
> code a bit by removing the need for the separate tunnelcreek cells array
> and combining some of the add/remove logic.
> 
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>,
> Cc: Denis Turischev <denis@compulab.co.il>,
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> ---
>  drivers/mfd/lpc_sch.c | 148 ++++++++++++++++++++++++--------------------------
>  1 file changed, 70 insertions(+), 78 deletions(-)
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
