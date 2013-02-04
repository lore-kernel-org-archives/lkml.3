Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3BDKsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 05:48:38 -0500
Received: from www.linutronix.de ([62.245.132.108]:42990 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab3BDKsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 05:48:37 -0500
Date: Mon, 4 Feb 2013 11:48:24 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-rt-users@vger.kernel.org
Subject: Re: [PATCH] OF: Fixup resursive locking code paths
In-Reply-To: <1359138107-14159-1-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.LFD.2.02.1302041147420.11905@ionos>
References: <1359138107-14159-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013, Paul Gortmaker wrote:

> From: Thomas Gleixner <tglx@linutronix.de>
> 
> There is no real reason to use a rwlock for devtree_lock. It even
> could be a mutex, but unfortunately it's locked from cpu hotplug
> paths which can't schedule :(
> 
> So it needs to become a raw lock on rt as well.  The devtree_lock would
> be the only user of a raw_rw_lock, so we are better off cleaning up the
> recursive locking paths which allows us to convert devtree_lock to a
> read_lock.

Hmm. It's already a rw_lock. For RT we want to change that thing to a
raw_spinlock.

Thanks,

	tglx
