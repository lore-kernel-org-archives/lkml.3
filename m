Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828AbbAFVvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 16:51:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754299AbbAFVvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 16:51:51 -0500
Date: Tue, 6 Jan 2015 23:51:15 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 03/40] arm64/uaccess: fix sparse errors
Message-ID: <20150106215115.GA21594@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-4-git-send-email-mst@redhat.com>
 <20150106191432.GC32449@arm.com>
 <20150106214820.GA18895@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106214820.GA18895@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 11:48:20PM +0200, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2015 at 07:14:32PM +0000, Will Deacon wrote:
> > Hi Michael,
> > 
> > On Tue, Jan 06, 2015 at 03:43:40PM +0000, Michael S. Tsirkin wrote:
> > > virtio wants to read bitwise types from userspace using get_user.  At the
> > > moment this triggers sparse errors, since the value is passed through an
> > > integer.
> > > 
> > > Fix that up using __force.
> > > 
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > Acked-by: Will Deacon <will.deacon@arm.com>
> > > ---
> > 
> > Did you want us to take this via the arm64 tree, or are you planning to
> > merge it via another route?
> > 
> > Will
> 
> Up to you really: if you don't pick it up, Arnd said he'll merge
> through his tree.

Though if you do pick it up, need to also pick up the follow-up
patch - maybe my tree is easier.

> > >  arch/arm64/include/asm/uaccess.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
> > > index 3bf8f4e..9a2069b 100644
> > > --- a/arch/arm64/include/asm/uaccess.h
> > > +++ b/arch/arm64/include/asm/uaccess.h
> > > @@ -147,7 +147,7 @@ do {									\
> > >  	default:							\
> > >  		BUILD_BUG();						\
> > >  	}								\
> > > -	(x) = (__typeof__(*(ptr)))__gu_val;				\
> > > +	(x) = (__force __typeof__(*(ptr)))__gu_val;			\
> > >  } while (0)
> > >  
> > >  #define __get_user(x, ptr)						\
> > > -- 
> > > MST
> > > 
> > > 
