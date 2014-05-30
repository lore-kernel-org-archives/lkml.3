Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbaE3Is2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 04:48:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:39393 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665AbaE3Is0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 04:48:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,939,1392192000"; 
   d="scan'208";a="520132346"
Date: Fri, 30 May 2014 11:48:22 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: eric.ernst@linux.intel.com
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Subject: Re: [PATCH 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
Message-ID: <20140530084822.GC1645@lahna.fi.intel.com>
References: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 12:26:44PM -0700, eric.ernst@linux.intel.com wrote:
> From: Eric Ernst <eric.ernst@linux.intel.com>
> 
> For Baytrail, you should never set a GPIO set to direct_irq
> to output mode.  When direct_irq_en is set for a GPIO, it is
> tied directly to an APIC internally, and making the pad output
> does not make any sense. Assert a WARN() in the event this happens.

Can't we just clear that flag when the GPIO is requested? Or is this
something which can't be done at this point?
