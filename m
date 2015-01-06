Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbbAFS16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 13:27:58 -0500
Received: from asavdk4.altibox.net ([109.247.116.15]:48850 "EHLO
	asavdk4.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755972AbbAFS14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 13:27:56 -0500
Date: Tue, 6 Jan 2015 19:27:49 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 26/40] arch/sparc: uaccess_64 macro whitespace fixes
Message-ID: <20150106182749.GA19490@ravnborg.org>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-27-git-send-email-mst@redhat.com>
 <20150106165339.GA11270@ravnborg.org>
 <20150106171902.GA11577@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106171902.GA11577@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 07:19:02PM +0200, Michael S. Tsirkin wrote:
> On Tue, Jan 06, 2015 at 05:53:39PM +0100, Sam Ravnborg wrote:
> > On Tue, Jan 06, 2015 at 05:44:56PM +0200, Michael S. Tsirkin wrote:
> > > Macros within arch/sparc/include/asm/uaccess_64.h are made harder to
> > > read because they violate a bunch of coding style rules.
> > > 
> > > Fix it up.
> > As per Davem's earlier mail please prefix using sparc32/sparc64.
> 
> I did put in uaccess_64 - insufficient?
sparc32: bla bla
For sparc32 specific changes.

sparc64: bla bla
For sparc64 specific changes

sparc: bla bla
For general sparce changes


In this case you could have used:
sparc64: fix coding style in uaccess_64.h

> 
> > > -#define __put_user_nocheck(data,addr,size) ({ \
> > > -register int __pu_ret; \
> > > -switch (size) { \
> > > -case 1: __put_user_asm(data,b,addr,__pu_ret); break; \
> > > -case 2: __put_user_asm(data,h,addr,__pu_ret); break; \
> > > -case 4: __put_user_asm(data,w,addr,__pu_ret); break; \
> > > -case 8: __put_user_asm(data,x,addr,__pu_ret); break; \
> > > -default: __pu_ret = __put_user_bad(); break; \
> > > -} __pu_ret; })
> > > -
> > > -#define __put_user_asm(x,size,addr,ret)					\
> > > +#define __put_user_nocheck(data, addr, size) ({ \
> > > +	register int __pu_ret; \
> > > +	switch (size) { \
> > > +	case 1: \
> > > +		__put_user_asm(data, b, addr, __pu_ret); \
> > > +		break; \
> > > +	case 2: \
> > > +		__put_user_asm(data, h, addr, __pu_ret); \
> > > +		break; \
> > > +	case 4: \
> > > +		__put_user_asm(data, w, addr, __pu_ret); \
> > > +		break; \
> > > +	case 8: \
> > > +		__put_user_asm(data, x, addr, __pu_ret); \
> > > +		break; \
> > > +	default: \
> > > +		__pu_ret = __put_user_bad(); \
> > > +		break; \
> > > +	} \
> > > +	__pu_ret; \
> > > +})
> > 
> > No matter what coding style says - the above is much less readable than the
> > original version.
> > 
> > 
> I guess you approve the rest of the changes then?
I did not look to carefully - but what I saw looked good.

> 
> 
> I get it you like it that 
> 	case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break;
> has the whole case on the same line?
> Is that the issue?
Exactly - much easier to read this way.
That the "\" was not aligned in these parts of the code did not help either.

	Sam
