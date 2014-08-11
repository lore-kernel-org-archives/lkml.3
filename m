Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043AbaHKMWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 08:22:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853AbaHKMWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 08:22:50 -0400
Date: Mon, 11 Aug 2014 08:22:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel <user-mode-linux-devel@lists.sourceforge.net>,
        sahne@0x90.at
Subject: Re: "resource: provide new functions to walk through resources"
 breaks UML
Message-ID: <20140811122229.GA26869@redhat.com>
References: <53E7A42E.4090702@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53E7A42E.4090702@nod.at>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 06:56:14PM +0200, Richard Weinberger wrote:
> Hi Vivek,
> 
> Daniel Walter reported that UML is currently broken.
> The offending commit is:
> 

Hi Richard,

Thanks for pointing it out. I will look into it.

Would you have link to the report Daniel sent. I am interested in 
looking at backtrace.

Thanks
Vivek

> commit 8c86e70acead629aacb4afcd818add66bf6844d9
> Author: Vivek Goyal <vgoyal@redhat.com>
> Date:   Fri Aug 8 14:25:50 2014 -0700
> 
>     resource: provide new functions to walk through resources
> 
> It dies in next_resource():
>         /* Caller wants to traverse through siblings only */
>         if (sibling_only)
>                 return p->sibling;
> 
> because p is NULL.
> Please note that UML has no iomem, maybe this is the problem...
> 
> Thanks,
> //richard
