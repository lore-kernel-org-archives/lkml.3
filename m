Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab3H0O1Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 10:27:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42555 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626Ab3H0O1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 10:27:23 -0400
Date: Tue, 27 Aug 2013 15:27:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Mark Salter <msalter@redhat.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arm64: move elf notes into readonly segment
Message-ID: <20130827142700.GB27164@darko.cambridge.arm.com>
References: <1377271002.7359.2.camel@deneb.redhat.com>
 <20130827104949.GE19897@arm.com>
 <1377608461.2127.15.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377608461.2127.15.camel@deneb.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 27, 2013 at 02:01:01PM +0100, Mark Salter wrote:
> On Tue, 2013-08-27 at 11:49 +0100, Catalin Marinas wrote:
> > On Fri, Aug 23, 2013 at 04:16:42PM +0100, Mark Salter wrote:
> > > The current vmlinux.lds.S places the notes sections between the
> > > end of rw data and start of bss. This means that _edata doesn't
> > > really point to the end of data. Since notes are read-only, this
> > > patch moves them to the read-only segment so that _edata does
> > > point to the end of initialized rw data.
> > > 
> > > Signed-off-by: Mark Salter <msalter@redhat.com>
> > > ---
> > >  arch/arm64/kernel/vmlinux.lds.S | 3 +--
> > >  1 file changed, 1 insertion(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/vmlinux.lds.S b/arch/arm64/kernel/vmlinux.lds.S
> > > index f5e5574..f8ab9d8 100644
> > > --- a/arch/arm64/kernel/vmlinux.lds.S
> > > +++ b/arch/arm64/kernel/vmlinux.lds.S
> > > @@ -71,6 +71,7 @@ SECTIONS
> > >  
> > >  	RO_DATA(PAGE_SIZE)
> > >  	EXCEPTION_TABLE(8)
> > > +	NOTES
> > >  	_etext = .;			/* End of text and rodata section */
> > >  
> > >  	. = ALIGN(PAGE_SIZE);
> > > @@ -122,8 +123,6 @@ SECTIONS
> > >  	}
> > >  	_edata_loc = __data_loc + SIZEOF(.data);
> > >  
> > > -	NOTES
> > > -
> > >  	BSS_SECTION(0, 0, 0)
> > >  	_end = .;
> > 
> > The _edata is set before NOTES, so I don't fully understand where the
> > problem is.
> > 
> The problem *is* _edata before the NOTES. We need a symbol to mark the
> end of initialized data. This should be _edata but _edata doesn't
> currently account for NOTES. In the EFI stub I'm working on, the PE/COFF
> header needs to know the end of the image. If we use _edata, we wouldn't
> include NOTES, so we're left with __bss_start. But _bss_start may not be
> exactly right because of alignment rounding and it is ugly to use for
> that purpose. So we either need a new symbol following NOTES, or move
> _edata past NOTES, or move NOTES. I chose the latter because NOTES are
> readonly and don't really need to be part of the RW segment.

OK, I got it now. I'll queue the patch for 3.12.

Thanks.

-- 
Catalin
