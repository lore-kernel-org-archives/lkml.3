Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935064Ab3FSSJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 14:09:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42657 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933869Ab3FSSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 14:09:29 -0400
Message-ID: <1371665367.2038.32.camel@joe-AO722>
Subject: Re: [patch -next] FMC: NULL dereference on allocation failure
From: Joe Perches <joe@perches.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: dan.carpenter@oracle.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Date: Wed, 19 Jun 2013 11:09:27 -0700
In-Reply-To: <20130619175758.GA23533@mail.gnudd.com>
References: <1371658504.2038.25.camel@joe-AO722>
	 <20130619160101.GA29108@mwanda> <20130619175758.GA23533@mail.gnudd.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 19:57 +0200, Alessandro Rubini wrote:
> >> +	arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
> >> +	arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);
> 
> > n comes from the hardware no?
> 
> Yes. Length of hardware description array.
> 
> > Maybe make these kcalloc too.
> 
> I'm not a fan of kcalloc. I think it removes readability. I remeber
> kernel patches to swap the arguments, because people get them wrong.

kcalloc's sole benefit is multiplication overflow protection.
If sizes are small and known, kcalloc isn't particularly useful.

Those kcalloc arg swap patches were just for style with no net effect.

> Even Kernighan said it was a design error (in "the practice of
> programming").  That said, I'm not the leader here.

I think the real design pattern error was realloc()

Anyway, no worries...

