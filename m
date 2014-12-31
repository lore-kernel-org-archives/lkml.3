Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781AbaLaFVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2014 00:21:07 -0500
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56682 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaLaFVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2014 00:21:05 -0500
Date: Wed, 31 Dec 2014 10:50:54 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Serguey Parkhomovsky <sergueyparkhomovsky@gmail.com>
Cc: Jeremiah Mahler <jmmahler@gmail.com>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        HPDD-discuss@ml01.01.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: lustre: linux-prim.c: fix sparse warnings about
 static declaration
Message-ID: <20141231052053.GA3389@sudip-PC>
References: <20141229111032.GA18686@fedora.localdomain>
 <20141230223518.GA31616@hudson.localdomain>
 <20141231030435.GA3775@fedora.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141231030435.GA3775@fedora.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 07:04:35PM -0800, Serguey Parkhomovsky wrote:
> On Tue, Dec 30, 2014 at 02:35:18PM -0800, Jeremiah Mahler wrote:
> > 
> > If you look at the source code just below these functions you will find:
> > 
> > EXPORT_SYMBOL(libcfs_arch_init);
> > EXPORT_SYMBOL(libcfs_arch_cleanup);
> > 
> > So making these static is incorrect because they are being used outside
> > of this file.
> > 
> 
> Thanks for the review, and sorry about the noise; I'll be more careful next time.

these tools are there to help you find the problems in the code.but after that we need to use our own judgement to decide.
in this case the solution is to declare them in libcfs.h

and please atleast buildtest your patch before sending. If you would have compiled this patch then you could have seen 2 new warnings:
"WARNING: "libcfs_arch_init" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!"
"WARNING: "libcfs_arch_cleanup" [drivers/staging/lustre/lustre/libcfs/libcfs.ko] undefined!"

thanks
sudip

> 
> Serguey
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
