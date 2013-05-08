Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab3EHWQ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 18:16:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38173 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520Ab3EHWQZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 18:16:25 -0400
Date: Wed, 8 May 2013 15:16:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, Christopher Li <sparse@chrisli.org>
Subject: Re: [patch] err.h: IS_ERR() can accept __user pointers
Message-Id: <20130508151622.87bde6d58f96ddca9561541f@linux-foundation.org>
In-Reply-To: <20130508074221.GA5024@elgon.mountain>
References: <CANeU7QnO8MzqT+9BDsXj3=nkKOBKumOwEKGnT=BL_cS0wiPPmw@mail.gmail.com>
	<20130508074221.GA5024@elgon.mountain>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013 10:42:22 +0300 Dan Carpenter <dan.carpenter@oracle.com> wrote:

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

You often put really important stuff after the ^--- and I always move
it to before the ^--- :)

