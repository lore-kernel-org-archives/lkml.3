Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaATISQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:18:16 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31379 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaATISN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:18:13 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-cd-52dcdbc21bfb
Message-id: <52DCDBC2.3000504@samsung.com>
Date: Mon, 20 Jan 2014 09:18:10 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>, Peng Tao <tao.peng@emc.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com>
In-reply-to: <20140117143329.GA6877@kroah.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t/xa7qHbt8JMjiwUcOi4dorVos9Z36x
	WzQvXs9mcXnXHDaLhg/X2RxYPe7tO8ziceTIbBaPxXteMnnsn7uG3ePzJrkA1igum5TUnMyy
	1CJ9uwSujC3zDjEVHOStmHjHooHxGlcXIyeHhICJxPvGDSwQtpjEhXvr2boYuTiEBJYySuy+
	f4UZwvnEKPHmUgcbSBWvgJbEnAOzgBIcHCwCqhL3e3RAwmwChhJdb7vASkQFQiX2fDzNCFEu
	KPFj8j2wBSICxhL9Z2exg8xkFmhjlHh5eDYzSEJYwEFiypG5YM1CAjkSyw6vZAKxOQX0JP79
	nQLWzCxgJvGoZR0zhC0vsXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFU0uTC4qT0nMN9YoTc4tL
	89L1kvNzNzFCAvrLDsbFx6wOMQpwMCrx8HZ43AkSYk0sK67MPcQowcGsJMK75TBQiDclsbIq
	tSg/vqg0J7X4ECMTB6dUA6PCMov1q7Y9PyxQ8ejDt7m6J/c/vuW27ZdfyPs/apemKMbmVNYx
	RPy+tdu445qZ8cWYSacUoi97WPOJLfg2y5DrgXfRnMzHJnp3soJMHapM5KwPTp79cevDQ38q
	gqSkv7NG1Mxe1Kpcs0nS7+gj7QlfOgsYuqf0vpn1WH9qnLNNymSGCLuVd7mUWIozEg21mIuK
	EwHBsEnnRgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-01-17 15:33, Greg Kroah-Hartman wrote:
> On Fri, Jan 17, 2014 at 09:46:56AM +0100, Marek Szyprowski wrote:
> > GFP_ATOMIC is not a single gfp flag, but a macro which expands to the other
> > flags and LACK of __GFP_WAIT flag. To check if caller wanted to perform an
> > atomic allocation, the code must test __GFP_WAIT flag presence.
> >
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > ---
> >  .../lustre/include/linux/libcfs/libcfs_private.h   |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
> > index d0d942c..dddccca1 100644
> > --- a/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
> > +++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_private.h
> > @@ -120,7 +120,7 @@ do {						\
> >  do {									    \
> >  	LASSERT(!in_interrupt() ||					    \
> >  		((size) <= LIBCFS_VMALLOC_SIZE &&			    \
> > -		 ((mask) & GFP_ATOMIC)) != 0);			    \
> > +		 ((mask) & __GFP_WAIT) == 0));				    \
> >  } while (0)
>
> What a horrible assert, can't we just remove this entirely?
> in_interrupt() usually should never be checked, if so, the code is doing
> something wrong.  And __GFP flags shouldn't be used on their own.

Well, I've prepared this patch when I was checking kernel sources for 
incorrect
GFP_ATOMIC usage. I agree that drivers should use generic memory allocation
methods instead of inventing their own stuff. Feel free to ignore my 
patch in
favor of removing this custom allocator at all.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

