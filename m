Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967Ab3CGLdo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 06:33:44 -0500
Received: from canardo.mork.no ([148.122.252.1]:32898 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab3CGLdn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 06:33:43 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, joe@perches.com,
        shangw@linux.vnet.ibm.com, linuxram@us.ibm.com
Subject: Re: [PATCH 2/2] driver-core: remove the duplicate assignment of kobj->parent in device_add
Organization: m
References: <1362622966-20003-1-git-send-email-weiyang@linux.vnet.ibm.com>
	<1362622966-20003-3-git-send-email-weiyang@linux.vnet.ibm.com>
Date: Thu, 07 Mar 2013 12:33:19 +0100
In-Reply-To: <1362622966-20003-3-git-send-email-weiyang@linux.vnet.ibm.com>
	(Wei Yang's message of "Thu, 7 Mar 2013 10:22:46 +0800")
Message-ID: <87li9zjvgg.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yang <weiyang@linux.vnet.ibm.com> writes:

> kobject_add() will setup the kobject parent correctly.
>
> This patch removes the redundant code.
>
> Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
> Reviewed-by: Ram Pai <linuxram@us.ibm.com>
> Reviewed-by: Gavin Shan <shangw@linux.vnet.ibm.com>
> ---
>  drivers/base/core.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 369ae4e..6b0a859 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1024,8 +1024,6 @@ int device_add(struct device *dev)
>  
>  	parent = get_device(dev->parent);
>  	kobj = get_device_parent(dev, parent);
> -	if (kobj)
> -		dev->kobj.parent = kobj;
>  
>  	/* use parent numa_node */
>  	if (parent)
> @@ -1033,7 +1031,7 @@ int device_add(struct device *dev)
>  
>  	/* first, register with generic layer. */
>  	/* we require the name to be set before, and pass NULL */
> -	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
> +	error = kobject_add(&dev->kobj, kobj, NULL);
>  	if (error)
>  		goto Error;


You've submitted this exact same patch before and Greg asked a couple of
questions about it: https://lkml.org/lkml/2013/1/25/599

If this is a resubmission, then it would sure be nice if that was clear
from the subject and on.  And I believe any previously asked questions
should be answered in some way.  I see that you have responded to one of
them by moving part of the commit message to the cover letter, but still
without any answer to the question.

To me this looks like you completely ignored Greg's review questions. Is
that so?



Bjørn
