Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaBCQpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 11:45:36 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:47188 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753106AbaBCQpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 11:45:31 -0500
Date: Mon, 3 Feb 2014 16:46:36 +0000
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "msalter@redhat.com" <msalter@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "patches@linaro.org" <patches@linaro.org>,
        "roy.franz@linaro.org" <roy.franz@linaro.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/5] arm: add new asm macro update_sctlr
Message-ID: <20140203164636.GJ11329@bivouac.eciton.net>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-3-git-send-email-leif.lindholm@linaro.org>
 <20140122112055.GF1621@mudshark.cambridge.arm.com>
 <20140129182805.GF11329@bivouac.eciton.net>
 <1391029124.2488.50.camel@deneb.redhat.com>
 <20140130131247.GG11329@bivouac.eciton.net>
 <20140203103415.GA12187@mudshark.cambridge.arm.com>
 <20140203155542.GI11329@bivouac.eciton.net>
 <20140203160051.GG14112@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140203160051.GG14112@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 03, 2014 at 04:00:51PM +0000, Will Deacon wrote:
> > > > With the two call sites in uefi_phys.S as:
> > > > 
> > > > 	ldr	r5, =(CR_M)
> > > > 	update_sctlr	r12, , r5
> > > > and
> > > > 	ldr	r4, =(CR_I | CR_C | CR_M)
> > > > 	update_sctlr	r12, r4
> > > 
> > > These ldr= could be movs, right?
> > 
> > The first one could.
> > The second one could be movw on armv7+.
> > 
> > > If so, I definitely prefer this to putting an ldr = into the macro itself
> > > (option 2).
> > 
> > And your preference between 1) and 2) is?
> 
> (1), using bic and mov[tw] where possible.

(1): ok, thanks.

bic: sure, that was an oversight.

mov[tw]: why?
Then we end up battling different available immediate fields in A32/T32
instruction sets and v5/v6/v7 architecture versions.

/
    Leif
