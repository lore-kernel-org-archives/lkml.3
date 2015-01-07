Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631AbbAGJz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:55:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbbAGJzY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:55:24 -0500
Date: Wed, 7 Jan 2015 11:55:10 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org, linux-metag@vger.kernel.org
Subject: Re: [PATCH v2 09/40] metag/uaccess: fix sparse errors
Message-ID: <20150107095510.GA24828@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
 <1420558883-10131-10-git-send-email-mst@redhat.com>
 <54AD00AC.2030801@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54AD00AC.2030801@imgtec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 07, 2015 at 09:47:24AM +0000, James Hogan wrote:
> Hi Machael,
> 
> On 06/01/15 15:43, Michael S. Tsirkin wrote:
> > virtio wants to read bitwise types from userspace using get_user.  At the
> > moment this triggers sparse errors, since the value is passed through an
> > integer.
> > 
> > Fix that up using __force.
> > 
> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  arch/metag/include/asm/uaccess.h | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/metag/include/asm/uaccess.h b/arch/metag/include/asm/uaccess.h
> > index 0748b0a..c314b45 100644
> > --- a/arch/metag/include/asm/uaccess.h
> > +++ b/arch/metag/include/asm/uaccess.h
> > @@ -135,7 +135,7 @@ extern long __get_user_bad(void);
> >  ({                                                              \
> >  	long __gu_err, __gu_val;                                \
> >  	__get_user_size(__gu_val, (ptr), (size), __gu_err);	\
> > -	(x) = (__typeof__(*(ptr)))__gu_val;                     \
> > +	(x) = (__force __typeof__(*(ptr)))__gu_val;                     \
> 
> As I mentioned before, can you please adjust the position of the \ to
> line up.
> >  	__gu_err;                                               \
> >  })
> >  
> > @@ -145,7 +145,7 @@ extern long __get_user_bad(void);
> >  	const __typeof__(*(ptr)) __user *__gu_addr = (ptr);		\
> >  	if (access_ok(VERIFY_READ, __gu_addr, size))			\
> >  		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
> > -	(x) = (__typeof__(*(ptr)))__gu_val;                             \
> > +	(x) = (__force __typeof__(*(ptr)))__gu_val;                             \
> 
> same here (this one causes checkpatch error due to 80 column limit).

Oops. Sorry. Will fix both. I won't repost unless there are more issues.

> 
> >  	__gu_err;                                                       \
> >  })
> >  
> > 
> 
> With those changes,
> Acked-by: James Hogan <james.hogan@imgtec.com>
> 
> Cheers
> James
> 


