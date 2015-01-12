Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753427AbbALQP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 11:15:57 -0500
Received: from mga09.intel.com ([134.134.136.24]:61079 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbbALQPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 11:15:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,744,1413270000"; 
   d="scan'208";a="649879368"
Message-ID: <1421079289.31978.34.camel@linux.intel.com>
Subject: Re: [PATCH] gpu:drm:Change calls to mdelay to msleep in the
 functions,send_pkg_prepare and send_pkg_done for the
 file,mdfld_dsi_pkg_sender.c
From: Alan Cox <alan@linux.intel.com>
To: Thierry Reding <treding@nvidia.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, airlied@linux.ie,
        airlied@redhat.com, damien.lespiau@intel.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 16:14:49 +0000
In-Reply-To: <20150112161233.GC16118@ulmo.nvidia.com>
References: <1420950664-18875-1-git-send-email-xerofoify@gmail.com>
	 <1421069367.31978.21.camel@linux.intel.com>
	 <20150112161233.GC16118@ulmo.nvidia.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 (3.12.9-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 17:12 +0100, Thierry Reding wrote:
> On Mon, Jan 12, 2015 at 01:29:27PM +0000, Alan Cox wrote:
> > On Sat, 2015-01-10 at 23:31 -0500, Nicholas Krause wrote:
> > > Changes various calls in the functions,send_pkg_prepare and send_pkg_done
> > > for mdelay to msleep. These changes are needed due to use working with
> > > various sleep modes supported by this hardware and thus needing to sleep
> > > for a small duration instead of using the respectful delay function due
> > > to the need to sleep rather then busy loop the CPU(s) and waste CPU cycles
> > > on the system that could be used to handle other tasks.
> > > 
> > > Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
> > 
> > NAK
> > 
> > Like every other TODO you've been mucking with at random this one is
> > there for a reason.
> > 
> > We can't sleep at this point.
> 
> From a quick look it seems like the only reason why we can't sleep is
> because sender->lock is a spinlock. But it would seem that it could
> simply be a mutex, in which case the delays could become sleeps.
> 
> Do you happen to remember if there were specific reasons to make this a
> spinlock rather than a mutex?

I don't remember the full details and since I don't currently have a
test platform for it, and its obsolete I don't want to touch it.

If someone else does fine, but they need to verify it on real hardware.

Alan


