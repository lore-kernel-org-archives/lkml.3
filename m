Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313AbbAFRTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:19:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbbAFRTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:19:18 -0500
Date: Tue, 6 Jan 2015 19:19:02 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH v2 26/40] arch/sparc: uaccess_64 macro whitespace fixes
Message-ID: <20150106171902.GA11577@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-27-git-send-email-mst@redhat.com>
 <20150106165339.GA11270@ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106165339.GA11270@ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 05:53:39PM +0100, Sam Ravnborg wrote:
> On Tue, Jan 06, 2015 at 05:44:56PM +0200, Michael S. Tsirkin wrote:
> > Macros within arch/sparc/include/asm/uaccess_64.h are made harder to
> > read because they violate a bunch of coding style rules.
> > 
> > Fix it up.
> As per Davem's earlier mail please prefix using sparc32/sparc64.

I did put in uaccess_64 - insufficient?

> > -#define __put_user_nocheck(data,addr,size) ({ \
> > -register int __pu_ret; \
> > -switch (size) { \
> > -case 1: __put_user_asm(data,b,addr,__pu_ret); break; \
> > -case 2: __put_user_asm(data,h,addr,__pu_ret); break; \
> > -case 4: __put_user_asm(data,w,addr,__pu_ret); break; \
> > -case 8: __put_user_asm(data,x,addr,__pu_ret); break; \
> > -default: __pu_ret = __put_user_bad(); break; \
> > -} __pu_ret; })
> > -
> > -#define __put_user_asm(x,size,addr,ret)					\
> > +#define __put_user_nocheck(data, addr, size) ({ \
> > +	register int __pu_ret; \
> > +	switch (size) { \
> > +	case 1: \
> > +		__put_user_asm(data, b, addr, __pu_ret); \
> > +		break; \
> > +	case 2: \
> > +		__put_user_asm(data, h, addr, __pu_ret); \
> > +		break; \
> > +	case 4: \
> > +		__put_user_asm(data, w, addr, __pu_ret); \
> > +		break; \
> > +	case 8: \
> > +		__put_user_asm(data, x, addr, __pu_ret); \
> > +		break; \
> > +	default: \
> > +		__pu_ret = __put_user_bad(); \
> > +		break; \
> > +	} \
> > +	__pu_ret; \
> > +})
> 
> No matter what coding style says - the above is much less readable than the
> original version.
> 
> 
I guess you approve the rest of the changes then?


I get it you like it that 
	case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break;
has the whole case on the same line?
Is that the issue?


> 
> > -#define __get_user_nocheck(data,addr,size,type) ({ \
> > -register int __gu_ret; \
> > -register unsigned long __gu_val; \
> > -switch (size) { \
> > -case 1: __get_user_asm(__gu_val,ub,addr,__gu_ret); break; \
> > -case 2: __get_user_asm(__gu_val,uh,addr,__gu_ret); break; \
> > -case 4: __get_user_asm(__gu_val,uw,addr,__gu_ret); break; \
> > -case 8: __get_user_asm(__gu_val,x,addr,__gu_ret); break; \
> > -default: __gu_val = 0; __gu_ret = __get_user_bad(); break; \
> > -} data = (__force type) __gu_val; __gu_ret; })
> > -
> > -#define __get_user_nocheck_ret(data,addr,size,type,retval) ({ \
> > -register unsigned long __gu_val __asm__ ("l1"); \
> > -switch (size) { \
> > -case 1: __get_user_asm_ret(__gu_val,ub,addr,retval); break; \
> > -case 2: __get_user_asm_ret(__gu_val,uh,addr,retval); break; \
> > -case 4: __get_user_asm_ret(__gu_val,uw,addr,retval); break; \
> > -case 8: __get_user_asm_ret(__gu_val,x,addr,retval); break; \
> > -default: if (__get_user_bad()) return retval; \
> > -} data = (__force type) __gu_val; })
> > -
> > -#define __get_user_asm(x,size,addr,ret)					\
> > +#define __get_user_nocheck(data, addr, size, type) ({ \
> > +	register int __gu_ret; \
> > +	register unsigned long __gu_val; \
> > +	switch (size) { \
> > +		case 1: \
> > +			__get_user_asm(__gu_val, ub, addr, __gu_ret); \
> > +			break; \
> > +		case 2: \
> > +			__get_user_asm(__gu_val, uh, addr, __gu_ret); \
> > +			break; \
> > +		case 4: \
> > +			__get_user_asm(__gu_val, uw, addr, __gu_ret); \
> > +			break; \
> > +		case 8: \
> > +			__get_user_asm(__gu_val, x, addr, __gu_ret); \
> > +			break; \
> > +		default: \
> > +			__gu_val = 0; \
> > +			__gu_ret = __get_user_bad(); \
> > +			break; \
> > +	} data = (__force type) __gu_val; __gu_ret; \
> > +})
> > +
> > +#define __get_user_nocheck_ret(data, addr, size, type, retval) ({ \
> > +	register unsigned long __gu_val __asm__ ("l1"); \
> > +	switch (size) { \
> > +	case 1: \
> > +		__get_user_asm_ret(__gu_val, ub, addr, retval); \
> > +		break; \
> > +	case 2: \
> > +		__get_user_asm_ret(__gu_val, uh, addr, retval); \
> > +		break; \
> > +	case 4: \
> > +		__get_user_asm_ret(__gu_val, uw, addr, retval); \
> > +		break; \
> > +	case 8: \
> > +		__get_user_asm_ret(__gu_val, x, addr, retval); \
> > +		break; \
> > +	default: \
> > +		if (__get_user_bad()) \
> > +			return retval; \
> > +	} \
> > +	data = (__force type) __gu_val; \
> > +})
> > +
> 
> Same comment for this code chunk.
> 
> 	Sam

Well I donnu.  When I had to fix bugs there, it was pretty confusing to
me, conding style is no a holy book but it's there for a reason.

Lack of spaces after comma makes it so much harder
to count parameters.

Also:

> > -default: if (__get_user_bad()) return retval; \
> > -} data = (__force type) __gu_val; })

return on same line with if and code after the closing {}
makes it look confusingly like the more conventional:

 if (__get_user_bad())
 	data = (__force type) __gu_val;

-- 
MST
