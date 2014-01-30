Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaA3WTz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 17:19:55 -0500
Received: from relay1.sgi.com ([192.48.179.29]:55422 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaA3WTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 17:19:54 -0500
Date: Thu, 30 Jan 2014 16:19:50 -0600
From: Alex Thorlton <athorlton@sgi.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Fleming <matt@console-pimps.org>,
        Russ Anderson <rja@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140130221950.GJ3105@sgi.com>
References: <52E2ADB1.2030007@zytor.com>
 <20140124183730.GC11788@pd.tnic>
 <20140124184842.GD11788@pd.tnic>
 <20140124191709.GT18196@sgi.com>
 <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140129141822.GC24887@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Re-adding lkml.

Here's what we've got as far as your questions go (snipped from an
e-mail from Russ):

<snip>
> * what kind of a pointer is that, physical address, or?

The quick answer is I think it is a virtual address, because                                                                                                                                                                                                                                                                 
it does not work in physical mode.  If you ever see "virtefi"                                                                                                                                                                                                                                                                
on the RHEL bootline it is because RH switched the default                                                                                                                                                                                                                                                                   
to physical mode, which caused UV to not boot.  "virtefi"                                                                                                                                                                                                                                                                    
forced it back to virtual mode.

> * does it get switched to a virtual address after
> SetVirtualAddressMap()?

I believe SetVirtualAddressMap() creates the virtual mappings,                                                                                                                                                                                                                                                               
but I would have to look at the code to be sure.

> * Which region in your UEFI map contains that function, what are the
> modalities about mapping it?

Not sure about the region.  The MMRs are in a uncached range                                                                                                                                                                                                                                                                 
and the functions are cached marked executable.  But have to                                                                                                                                                                                                                                                                 
double check on that.
</snip>

> * Anything else I should know?

Probably, but nothing that's jumping out at us right now :)

Let us know if you need anything else.

Thanks!

- Alex
