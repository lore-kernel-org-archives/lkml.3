Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546Ab3AaVBM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:01:12 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:54096 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab3AaVBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:01:08 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org
Subject: Re: [PATCH] parisc: unbreak automounter support on 64-bit kernel with 32-bit userspace
Date: Thu, 31 Jan 2013 22:00:48 +0100
Message-ID: <2592015.Y1QhlXoLiz@donald.sf-tec.de>
User-Agent: KMail/4.9.5 (Linux/3.7.1-17-desktop; KDE/4.9.5; i686; ; )
In-Reply-To: <1359664008.2468.5.camel@dabdike>
References: <20130131200110.GA6032@p100.box> <1359664008.2468.5.camel@dabdike>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart45324376.8a8teivU1l"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart45324376.8a8teivU1l
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-15"

James Bottomley wrote:
> [adding autofs list and maintainer for their perusal and ack, although
> this is an obvious fix to me
> 
> James]
> 
> On Thu, 2013-01-31 at 21:01 +0100, Helge Deller wrote:
> > Similiar to other 64 bit Linux targets autofs_wqt_t needs to be of type
> > int
> > which has a size of 32 bits on 32- and 64-bit parisc kernels.
> > 
> > Signed-off-by: Helge Deller <deller@gmx.de>
> > 
> > diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
> > index 77cdba9..d551754 100644
> > --- a/include/uapi/linux/auto_fs.h
> > +++ b/include/uapi/linux/auto_fs.h
> > @@ -43,7 +43,7 @@
> > 
> >   */
> >  
> >  #if defined(__sparc__) || defined(__mips__) || defined(__x86_64__) \
> > 
> > - || defined(__powerpc__) || defined(__s390__)
> > + || defined(__powerpc__) || defined(__s390__) || defined(__hppa__)
> > 
> >  typedef unsigned int autofs_wqt_t;
> >  #else
> >  typedef unsigned long autofs_wqt_t;

Wouldn't it make sense to make it an unsigned int on all platforms? This 
wouldn't make any difference on 32 bit platforms and would prevent that to 
happen on the next 32-on-64 bit platform again.

Eike
--nextPart45324376.8a8teivU1l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEUEABECAAYFAlEK24kACgkQXKSJPmm5/E4eogCY8VrIpEp4IWJsOHUsbHtWX0pR
nACaA4CBIBelTgfB5BdN+X6lerbw3KM=
=B7+V
-----END PGP SIGNATURE-----

--nextPart45324376.8a8teivU1l--

