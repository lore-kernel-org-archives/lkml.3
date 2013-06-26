Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752955Ab3FZTcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:32:08 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:39508 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab3FZTcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:32:05 -0400
Date: Wed, 26 Jun 2013 21:31:58 +0200
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Message-ID: <20130626193158.GF9078@rocoto.smurfnet.nu>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org>
 <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <51CB33BE.2020601@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CB33BE.2020601@wwwdotorg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 12:32:30PM -0600, Stephen Warren wrote:
> >> What about ARMv8? Is the intention to have a separate definition for the
> >> UEFI bindings on ARMv8, so that compatibility isn't an issue? What if a
> >> future version of UEFI allows LPAE usage?
> > 
> > It is unlikely that will happen on v7 since newer versions of UEFI are
> > expected to remain backwards compatible with the current spec.
> 
> The expectation of backwards-compatibility sounds nice, but it seems a
> little dangerous to outright rely on it.
> 
> Even if not a regular compatible property, can we define a property that
> indicates the UEFI revision or revision of this DT binding, so that if
> we ever have to change it, there is some way of explicitly indicating
> which exact schema the DT corresponds to, rather than having to
> reverse-engineer it from the set of properties that "just happen" to be
> present in DT?
>
> This is rather like the firmware node discussion that happened recently,
> where we were expecting to represent a firmware (secure mode) interface
> by a DT node, which would have a compatible value, which in turn would
> convey information about which "OS" the secure firmware was running, and
> well as any potential SoC-/OEM-/board-specific interface provided by it.
> 
> And who knows, what if UEFI gets replaced someday; presumably we'd want
> some way of explicitly stating "running under UEFI" vs. "running under
> something else"?

To me, these concerns are all covered by the existence of the
efi-system-table node, and the version number that you can extract
from the table (mandatory in any UEFI implementation) located at that
address. There is no reverse-engineering involved.

/
    Leif
