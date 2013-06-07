Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab3FGFTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 01:19:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:5835 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3FGFTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 01:19:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,819,1363158000"; 
   d="scan'208";a="349512993"
Date: Fri, 7 Jun 2013 08:23:53 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, Jean Delvare <khali@linux-fr.org>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] i2c: designware: fix race between subsequent xfers
Message-ID: <20130607052353.GB11878@intel.com>
References: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370526216-10060-1-git-send-email-christian.ruppert@abilis.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Thu, Jun 06, 2013 at 03:43:35PM +0200, Christian Ruppert wrote:
> The designware block is not always properly disabled in the case of
> transfer errors. Interrupts from aborted transfers might be handled
> after the data structures for the following transfer are initialised but
> before the hardware is set up. This might corrupt the data structures to
> the point that the system is stuck in an infinite interrupt loop (where
> FIFOs are never emptied).
> This patch cleanly disables the designware-i2c hardware at the end of
> every transfer, successful or not.

Have you tried with the latest mainline driver? There is a commit that
solves similar problem:

2a2d95e9d6d29e7	i2c: designware: always clear interrupts before enabling them

Maybe it helps?
