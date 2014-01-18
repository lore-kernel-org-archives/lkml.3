Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbaAROYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 09:24:33 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:37412 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155AbaAROYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 09:24:31 -0500
Date: Sat, 18 Jan 2014 17:24:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: devel@driverdev.osuosl.org, James Hogan <james.hogan@imgtec.com>,
        andreas.dilger@intel.com, Greg KH <gregkh@linuxfoundation.org>,
        bergwolf@gmail.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        oleg.drokin@intel.com, jacques-charles.lafoucriere@cea.fr,
        jinshan.xiong@intel.com, linux-metag@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: lustre: lustre: include: add
 "__attribute__((packed))" for the related union
Message-ID: <20140118142404.GT7444@mwanda>
References: <52DA4E6A.1000308@gmail.com>
 <20140118100547.GS7444@mwanda>
 <52DA56C2.5010802@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DA56C2.5010802@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 06:26:10PM +0800, Chen Gang wrote:
> On 01/18/2014 06:05 PM, Dan Carpenter wrote:
> > On Sat, Jan 18, 2014 at 05:50:34PM +0800, Chen Gang wrote:
> >> Unfortunately, not all compilers assumes the structures within a pack
> >> region also need be packed (e.g. metag), so need add a pack explicitly
> >> to satisfy all compilers.
> >>
> >> The related error (under metag with allmodconfig):
> >>
> >>     CC [M]  drivers/staging/lustre/lustre/lov/lov_pack.o
> >>   drivers/staging/lustre/lustre/lov/lov_pack.c: In function 'lov_getstripe':
> >>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: duplicate case value
> >>   drivers/staging/lustre/lustre/lov/lov_pack.c:630: error: previously used here
> >>
> >> And originally, all related code used "__attribute__((packed))", so
> >> still use it instead of '__packed'.
> > 
> > Use __packed.  Then at least one line will be correct which is better
> > than nothing.
> > 
> 
> Hmm... but that will break the 'consistency' (which is not quite good
> for readers).
> 
> For me, it will be better to provide another patch to change all
> "__attribute__((packed))" to "__packed" within this file.
> 
> What about your ideas?
> 

In the end, it's not something we care about enough to ask you to redo
the patch.  But what I'm saying is that you should prefer kernel style
over local style.  We'll fix the surrounding lines later.

regards,
dan carpenter

