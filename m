Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3EHIjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:39:25 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42462 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537Ab3EHIjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:39:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130508074221.GA5024@elgon.mountain>
References: <CANeU7QnO8MzqT+9BDsXj3=nkKOBKumOwEKGnT=BL_cS0wiPPmw@mail.gmail.com>
	<20130508074221.GA5024@elgon.mountain>
Date: Wed, 8 May 2013 01:39:22 -0700
X-Google-Sender-Auth: Jl5UeJjvispPi5PvmihsTl_Vm9Y
Message-ID: <CANeU7QmvYsWXVdhvttN0xV-PBga6ro1_Qne7vGbb7hZ8Fhw-aA@mail.gmail.com>
Subject: Re: [patch] err.h: IS_ERR() can accept __user pointers
From: Christopher Li <sparse@chrisli.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 8, 2013 at 12:42 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Sparse generates a false positive when you pass a __user or __iomem
> pointer to the IS_ERR() functions.
>
> drivers/rtc/rtc-ds1286.c:344:36: sparse: incorrect type in argument 1 (different address spaces)
> drivers/rtc/rtc-ds1286.c:344:36:    expected void const *ptr
> drivers/rtc/rtc-ds1286.c:344:36:    got unsigned int [noderef] [usertype] <asn:2>*rtcregs
>
> We can silence these by adding a __force here and upgrading to the
> latest git release of Sparse.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
> This change has no effect when using current Sparse releases.

Acked.

Chris
