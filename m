Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384AbaDBC0s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 22:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaDBC0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 22:26:46 -0400
Date: Tue, 1 Apr 2014 19:28:58 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Loc Ho <lho@apm.com>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches for 3.15-rc1
Message-ID: <20140402022858.GA4901@kroah.com>
References: <20140401184916.GA21938@kroah.com>
 <CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwf6e-hkF+4ND0DaAKDmLX8P8+xWCgs5BRnARdSsq9tpw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 01, 2014 at 05:28:19PM -0700, Linus Torvalds wrote:
> On Tue, Apr 1, 2014 at 11:49 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > USB patches for 3.15-rc1
> >
> > Here's the big USB pull request for 3.15-rc1.
> 
> Hmm. I'm getting this when testing:
> 
>   warning: (AHCI_XGENE) selects PHY_XGENE which has unmet direct
> dependencies (HAS_IOMEM && OF && (ARM64 || COMPILE_TEST))
> 
> which looks like AHCI_XGENE doesn't have the proper dependency on OF
> (or alternatively PHY_XGENE has an incorrect dependemcy on OF).
> 
> According to google it looks like Fengguang reported this on
> kbuild-all, but nowhere else.
> 
> The actual build then succeeds. But the Kconfig warning is real and
> implies that something is seriously wrong wrt the dependencies for
> this thing.
> 
> It looks like the "select PHY_XGENE" came in through the libata
> update, but this USB update actually brought in the "config PHY_XGENE"
> and thus this error. Which makes me wonder how this all worked. Why
> does that "select PHY_XGENE" exist when apparently it's not needed?
> 
> Regardless, there's something broken somewhere.

Odd, I don't know what to do to fix this up "properly".

Loc Ho, this came in from your patch, any ideas?

thanks,

greg k-h
