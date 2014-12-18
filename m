Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858AbaLRWso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:48:44 -0500
Received: from mga03.intel.com ([134.134.136.65]:14162 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaLRWsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:48:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,603,1413270000"; 
   d="scan'208";a="656706886"
Date: Thu, 18 Dec 2014 14:48:36 -0800
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] genirq: fix symbol export for __irq_set_affinity
Message-ID: <20141218144836.0000091d@unknown>
In-Reply-To: <alpine.DEB.2.11.1412182340300.17382@nanos>
References: <20141218223031.23847.86103.stgit@jbrandeb-cp2.jf.intel.com>
	<alpine.DEB.2.11.1412182340300.17382@nanos>
X-Mailer: Claws Mail 3.7.10cvs7 (GTK+ 2.16.6; i586-pc-mingw32msvc)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014 23:42:03 +0100
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 18 Dec 2014, Jesse Brandeburg wrote:
> > Enabling this function means that kernel drivers can include
> > an initial affinity setting for the interrupt, instead of all
> > interrupts starting out life on CPU0.  It seems to have just
> > been an oversight that it was not included.

> And why needs this to be called from modules? Just because or is there
> a legitimate reason? IOW, you forgot to describe the actual usecase.

As stated above, the use case for my interest is making a network
driver's many interrupt vectors not all show up on CPU0.  Of course a
user can work around this by manually tuning smp_affinity, but I have
seen many reports from users and testers where the performance of the
network was really bad due to all network interrupts on CPU0.

This allows the driver to set a sane default smp_affinity value at
driver load.

Would you instead consider a patch where if a user calls the
set_irq_affinity_hint that the initial affinity is set to the hinted
value?
