Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751315AbaEGS6s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 14:58:48 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45630 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbaEGS6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 14:58:47 -0400
Date: Wed, 7 May 2014 19:58:22 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "David E. Box" <david.e.box@linux.intel.com>, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
        jacob.jun.pan@linux.intel.com
Subject: Re: [PATCH v3] x86/iosf: Make IOSF driver modular and usable by
 more drivers
Message-ID: <20140507195822.2d5dea58@alan.etchedpixels.co.uk>
In-Reply-To: <536A69E8.6070707@zytor.com>
References: <1398810789-2301-1-git-send-email-david.e.box@linux.intel.com>
	<1399052199-8703-1-git-send-email-david.e.box@linux.intel.com>
	<20140507174801.20fc0d67@alan.etchedpixels.co.uk>
	<536A67B8.1080805@zytor.com>
	<20140507181042.7b4dff18@alan.etchedpixels.co.uk>
	<536A69E8.6070707@zytor.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I guess I don't see why the module isn't removable.  Of course, any
> driver which calls iosf_mbi_available() will depend on it, preventing
> removal until *those* modules have been removed...

Going back over the current version you could unload it but you rely upon
the iosf_mbi_available caller locking the module in memory (which I think
is fair) and someone not forcing a hot unplug of any kind from userspace,
in which case life gets a bit odd as we clear mbi_pdev in the exit method
not when the device is unplugged. Probably for the best as with a remove
method you'd need to check the mbi_pdev pointer inside iosf_mbi_lock and
also clear it under the lock.

Alan
