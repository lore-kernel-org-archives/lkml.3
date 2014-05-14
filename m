Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaENJvG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:51:06 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:35767 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839AbaENJvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:51:00 -0400
Date: Wed, 14 May 2014 12:50:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Ben Myers <bpm@sgi.com>
Subject: Re: [ 137/143] xfs: underflow bug in xfs_attrlist_by_handle()
Message-ID: <20140514095020.GC16836@mwanda>
References: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
 <20140512003206.396224510@1wt.eu>
 <20140513110812.GA4006@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140513110812.GA4006@hercules>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:08:12PM +0100, Luis Henriques wrote:
> > diff --git a/fs/xfs/linux-2.6/xfs_ioctl32.c b/fs/xfs/linux-2.6/xfs_ioctl32.c
> > index bad485a..782d03d 100644
> > --- a/fs/xfs/linux-2.6/xfs_ioctl32.c
> > +++ b/fs/xfs/linux-2.6/xfs_ioctl32.c
> > @@ -361,8 +361,8 @@ xfs_compat_attrlist_by_handle(
> >  	if (copy_from_user(&al_hreq, arg,
> >  			   sizeof(compat_xfs_fsop_attrlist_handlereq_t)))
> >  		return -XFS_ERROR(EFAULT);
> > -	if (al_hreq.buflen > XATTR_LIST_MAX)
> > -		return -XFS_ERROR(EINVAL);
> 
> Am I missing something or was the above return statement deleted by
> mistake?
> 
> Cheers,
> --
> Luís

Good eye.  I have created a Smatch check to look for these bugs.

regards,
dan carpenter

