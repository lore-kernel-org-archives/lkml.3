Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbaFBTOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:14:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:22974 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752036AbaFBTOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:14:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,958,1392192000"; 
   d="scan'208";a="550400895"
Date: Mon, 2 Jun 2014 22:14:16 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: eric ernst <eric.ernst@linux.intel.com>
Cc: linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        mark.gross@intel.com
Subject: Re: [PATCH 1/1] PINCTRL: Warn if direct IRQ GPIO set to output
Message-ID: <20140602191416.GD1730@lahna.fi.intel.com>
References: <1401218804-77997-1-git-send-email-eric.ernst@linux.intel.com>
 <20140530084822.GC1645@lahna.fi.intel.com>
 <538CC3E4.2080700@linux.intel.com>
 <20140602191322.GC1730@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140602191322.GC1730@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:13:22PM +0300, Mika Westerberg wrote:
> On Mon, Jun 02, 2014 at 11:35:16AM -0700, eric ernst wrote:
> > On 14-05-30 01:48 AM, Mika Westerberg wrote:
> > >On Tue, May 27, 2014 at 12:26:44PM -0700, eric.ernst@linux.intel.com wrote:
> > >>From: Eric Ernst <eric.ernst@linux.intel.com>
> > >>
> > >>For Baytrail, you should never set a GPIO set to direct_irq
> > >>to output mode.  When direct_irq_en is set for a GPIO, it is
> > >>tied directly to an APIC internally, and making the pad output
> > >>does not make any sense. Assert a WARN() in the event this happens.
> > >Can't we just clear that flag when the GPIO is requested? Or is this
> > >something which can't be done at this point?
> > The IRQ setting for that register (the IRQ wiring via direct_irq_en) should
> > be set statically on boot, and should not be changed, let alone allowing for
> > multiple changes during runtime.
> 
> OK.
> 
> Please then follow the coding conventions documented in
> Documentation/SubmittingPatches and also check that

Documentation/CodingStyle, that is.

> scripts/checkpatch.pl doesn't complain too much.
