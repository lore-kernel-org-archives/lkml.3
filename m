Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab3JQMFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 08:05:25 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:40373 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753222Ab3JQMFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 08:05:24 -0400
Date: Thu, 17 Oct 2013 13:05:19 +0100
From: Matt Fleming <matt@console-pimps.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Fleming, Matt" <matt.fleming@intel.com>
Subject: Re: [PATCH 5/5] efi: Capsule update support and pstore backend
Message-ID: <20131017120519.GF10834@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
 <1381931460-6999-6-git-send-email-matt@console-pimps.org>
 <20131016141939.GA28684@srcf.ucam.org>
 <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31D31122@ORSMSX106.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Oct, at 02:52:25PM, Luck, Tony wrote:
> > Where by "May not function correctly" you mean "May crash the system"? 
> > I'm a little uneasy having this run by default if enabled, even if it's 
> > disabled by default in the config.
> 
> There's also an "either/or" choice between using efi-capsule with pstore, and the
> traditional kexec/kdump method for getting a memory dump from a crash.  We
> have to go through a reset to save the capsule - but we don't want a reset for
> kexec.   Perhaps we can pass the reset parameters through the kexec path to
> the new kernel to make it do the right kind of reset ... but the value of the capsule
> dump is minimal if kdump managed to dump everything.
 
I admit that using kexec with the EFI capsule + pstore code is not
something I'd considered. Though as you say, if you manage to jump to
your crash kernel I'm not sure how much use the capsule would be.

-- 
Matt Fleming, Intel Open Source Technology Center
