Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaFJQpr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 12:45:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:33499 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbaFJQpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 12:45:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,1009,1392192000"; 
   d="scan'208";a="545797547"
Message-ID: <1402418724.13849.149.camel@acox1-desk.ger.corp.intel.com>
Subject: Re: [PATCH] i2o/memory.c : Use kstrdup
From: Alan Cox <alan@linux.intel.com>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-kernel@vger.kernel.org, julia.lawall@lip6.fr
Date: Tue, 10 Jun 2014 17:45:24 +0100
In-Reply-To: <20140610161113.GA3989@himangi-Dell>
References: <20140610161113.GA3989@himangi-Dell>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-06-10 at 21:41 +0530, Himangi Saraogi wrote:
> Use kstrdup when the goal of an allocation is copy a string into the
> allocated region.
> 
> The Coccinelle semantic patch that makes this change is as follows:
> 
> // <smpl>
> @@
> expression from,to;
> expression flag,E1,E2;
> statement S;
> @@
> 
> -  to = kmalloc(strlen(from) + 1,flag);
> +  to = kstrdup(from, flag);
>    ... when != \(from = E1 \| to = E1 \)
>    if (to==NULL || ...) S
>    ... when != \(from = E2 \| to = E2 \)
> -  strcpy(to, from);
> // </smpl>
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> ---
> To send to: linux-kernel@vger.kernel.org
>  drivers/message/i2o/memory.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)


I no longer have any I2O hardware so I'm unable to test this. Looks
right but does anyone actually still use these drivers ????

Alan


