Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754295Ab3AaU04 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 15:26:56 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49716 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753398Ab3AaU0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 15:26:55 -0500
Message-ID: <1359664008.2468.5.camel@dabdike>
Subject: Re: [PATCH] parisc: unbreak automounter support on 64-bit kernel
 with 32-bit userspace
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Helge Deller <deller@gmx.de>
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ian Kent <raven@themaw.net>, autofs@vger.kernel.org
Date: Fri, 01 Feb 2013 07:26:48 +1100
In-Reply-To: <20130131200110.GA6032@p100.box>
References: <20130131200110.GA6032@p100.box>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.6.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding autofs list and maintainer for their perusal and ack, although
this is an obvious fix to me

James]
On Thu, 2013-01-31 at 21:01 +0100, Helge Deller wrote:
> Similiar to other 64 bit Linux targets autofs_wqt_t needs to be of type int
> which has a size of 32 bits on 32- and 64-bit parisc kernels.
> 
> Signed-off-by: Helge Deller <deller@gmx.de>
> 
> diff --git a/include/uapi/linux/auto_fs.h b/include/uapi/linux/auto_fs.h
> index 77cdba9..d551754 100644
> --- a/include/uapi/linux/auto_fs.h
> +++ b/include/uapi/linux/auto_fs.h
> @@ -43,7 +43,7 @@
>   */
>  
>  #if defined(__sparc__) || defined(__mips__) || defined(__x86_64__) \
> - || defined(__powerpc__) || defined(__s390__)
> + || defined(__powerpc__) || defined(__s390__) || defined(__hppa__)
>  typedef unsigned int autofs_wqt_t;
>  #else
>  typedef unsigned long autofs_wqt_t;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


