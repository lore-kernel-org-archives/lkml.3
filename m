Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238AbaIRJy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 05:54:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:14617 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935AbaIRJy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 05:54:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,546,1406617200"; 
   d="scan'208";a="601514995"
Date: Thu, 18 Sep 2014 12:53:49 +0300
From: Mika Westerberg <mika.westerberg@intel.com>
To: Loic Poulain <loic.poulain@intel.com>
Cc: linus.walleij@linaro.org, heikki.krogerus@linux.intel.com,
        mathias.nyman@linux.intel.com, samuel.ortiz@intel.com,
        linux-kernel@vger.kernel.org, Eric Ernst <eric.ernst@linux.intel.com>
Subject: Re: [PATCHv2] pinctrl: baytrail: Clear DIRECT_IRQ bit
Message-ID: <20140918095349.GH10854@lahna.fi.intel.com>
References: <1410961621-15231-1-git-send-email-loic.poulain@intel.com>
 <20140918074910.GC10854@lahna.fi.intel.com>
 <541AA677.7050907@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <541AA677.7050907@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 11:31:35AM +0200, Loic Poulain wrote:
> Warn seems necessary because we unconditionally change
> the pin behavior, I didn't meet any case where direct irq is truly
> used on our platform. But maybe it could happen?
> Don't want to cause any hidden regression.

The datasheet says 

"""
This bit should be cleared if io access mode is selected
for this pad
"""

If I interpret it right, it means that whenever this pad is functioning
as a GPIO the flag should be cleared. That's precisely the case here.

> Moreover if it is confirmed that is an hardware issue (BIOS),
> We can just keep this patch locally as a workaround and revert
> it later once our BIOS fixed.

True but only if there aren't any machines out there with this flaw in
the BIOS.
