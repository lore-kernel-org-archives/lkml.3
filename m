Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079AbaAaKHk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:07:40 -0500
Received: from mail.skyhub.de ([78.46.96.112]:39016 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbaAaKHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:07:37 -0500
Date: Fri, 31 Jan 2014 11:07:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Alex Thorlton <athorlton@sgi.com>, Matt Fleming <matt@console-pimps.org>,
        Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140131100722.GA21873@pd.tnic>
References: <20140124184842.GD11788@pd.tnic>
 <20140124191709.GT18196@sgi.com>
 <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52EAD0F2.7090101@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 30, 2014 at 02:23:46PM -0800, H. Peter Anvin wrote:
> On 01/30/2014 02:19 PM, Alex Thorlton wrote:
> >
> > The quick answer is I think it is a virtual address, because it does
> > not work in physical mode. If you ever see "virtefi" on the RHEL
> > bootline it is because RH switched the default to physical mode,
> > which caused UV to not boot. "virtefi" forced it back to virtual
> > mode.
> > 
> That is interesting, as it is definitely not the direction we have been
> going in within the Linux community.

Right, for the new scheme to work, we'll have to map the region
containing the code for uv_systab->function in order to do all those
uv_bios_call()'s. Physical/virtual shouldn't matter all that much
because we map the region *both* as a 1:1 map and in virtual space too.

Can SGI please give us a reliable way to do that during boot?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
