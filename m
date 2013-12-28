Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3L1Ofy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 09:35:54 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3L1Ofx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 09:35:53 -0500
Date: Sat, 28 Dec 2013 14:35:47 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Alex <xor@xor.bz>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: TSC Problems (warp between CPUs)
Message-ID: <20131228143547.38d0a0b9@alan.etchedpixels.co.uk>
In-Reply-To: <fcade74fbf715ff965b5a1d3b21e2c21@xor.bz>
References: <b65bbca027bb2a473f989e60871c2dd2@xor.bz>
	<fcade74fbf715ff965b5a1d3b21e2c21@xor.bz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> not guaranteed to be precise. For example a SMI (System Management 
> Interrupt) could interrupt the software flow that is attempting to write 
> the time-stamp counter immediately prior to the WRMSR. This could mean 
> the value written to the TSC could vary by thousands to millions of 
> clocks.

Yes SMI is a disaster area for any real time activity (and many other
things ;) ), but many systems actually make little use of it, especially
once the USB is owned by the OS.

For synchronization you can retry the sync if it isn't within an
acceptable range. The odds of getting an SMI mid sync setup should be
very very low, so the odds of repeating the failure several times should
be negligible and after a few tries you could give up and assume the
hardware is buggered then fall back to HPET.

Alan
