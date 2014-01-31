Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932292AbaAaOCY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 09:02:24 -0500
Received: from relay1.sgi.com ([192.48.179.29]:60537 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaAaOCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 09:02:22 -0500
Date: Fri, 31 Jan 2014 08:02:21 -0600
From: Russ Anderson <rja@sgi.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Alex Thorlton <athorlton@sgi.com>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [BUG] Linux 3.14 fails to boot with new EFI changes
Message-ID: <20140131140220.GC22498@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20140124191709.GT18196@sgi.com>
 <20140127222129.GK6839@pd.tnic>
 <20140128110552.GA815@pd.tnic>
 <20140128200754.GZ18196@sgi.com>
 <20140128225905.GN815@pd.tnic>
 <20140128234036.GB18196@sgi.com>
 <20140129141822.GC24887@pd.tnic>
 <20140130221950.GJ3105@sgi.com>
 <52EAD0F2.7090101@zytor.com>
 <20140131100722.GA21873@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140131100722.GA21873@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 31, 2014 at 11:07:22AM +0100, Borislav Petkov wrote:
> On Thu, Jan 30, 2014 at 02:23:46PM -0800, H. Peter Anvin wrote:
> > On 01/30/2014 02:19 PM, Alex Thorlton wrote:
> > >
> > > The quick answer is I think it is a virtual address, because it does
> > > not work in physical mode. If you ever see "virtefi" on the RHEL
> > > bootline it is because RH switched the default to physical mode,
> > > which caused UV to not boot. "virtefi" forced it back to virtual
> > > mode.
> > > 
> > That is interesting, as it is definitely not the direction we have been
> > going in within the Linux community.
> 
> Right, for the new scheme to work, we'll have to map the region
> containing the code for uv_systab->function in order to do all those
> uv_bios_call()'s. Physical/virtual shouldn't matter all that much
> because we map the region *both* as a 1:1 map and in virtual space too.
> 
> Can SGI please give us a reliable way to do that during boot?

I'm not sure what you are asking for.  We had a reliable way to
boot before the recent patch broke it. (commit
d2f7cbe7b26a74dbbbf8f325b2a6fd01bc34032c)


-- 
Russ Anderson,  Kernel and Performance Software Team Manager
SGI - Silicon Graphics Inc          rja@sgi.com
