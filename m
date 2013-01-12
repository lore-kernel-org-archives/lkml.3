Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3ALKwt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 05:52:49 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45371 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3ALKws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 05:52:48 -0500
Date: Sat, 12 Jan 2013 10:47:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFT 3/3] ARM: tegra: dts: seaboard: enable keyboard
Message-ID: <20130112104730.GQ23505@n2100.arm.linux.org.uk>
References: <1357911185-11048-1-git-send-email-ldewangan@nvidia.com> <1357911185-11048-3-git-send-email-ldewangan@nvidia.com> <50F09BC7.90607@wwwdotorg.org> <20130111232438.GN23505@n2100.arm.linux.org.uk> <50F09FCB.70809@wwwdotorg.org> <20130111233615.GO23505@n2100.arm.linux.org.uk> <50F0A2A8.3080401@wwwdotorg.org> <50F13C34.3020808@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F13C34.3020808@nvidia.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 12, 2013 at 04:04:28PM +0530, Laxman Dewangan wrote:
> Going through clock driver, the clk_get() should return error pointer or  
> valid pointer, atleast not NULL.

No.  clk_get() will return whatever value the 'clk' pointer found in
the clk_lookup structure contains.  Or it will return an error pointer.

This topic has had enough discussion in the past that I'll say: go and
look up in the archives emails from me on this subject.  I've been very
clear over the years about this.

> Probably our clock driver is returning to NULL and hence issue is  
> becasue whole world, it  check for IS_ERR or !IS_ERR() and null clk  
> pointer treated as !IS_ERR().

Probably not.  As far as _drivers_ go, either the clk cookie is an error
(IS_ERR() is true) _OR_ it is valid to be passed back into the clock API.
You will find statements from me in the past to that: whatever clk_get()
returns which is _not_ an error must be accepted by the rest of the clk
API.

Drivers never dereference the returned clk, so why should they care about
anything other than "is it an error" given by IS_ERR().  (notice the lack
of question mark, that's not a question to be answered.)
