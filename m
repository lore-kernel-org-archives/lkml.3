Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbaIVPqW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 11:46:22 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:33212 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbaIVPqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 11:46:20 -0400
Date: Mon, 22 Sep 2014 08:46:15 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Mikael Starvik <starvik@axis.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] resource: Add NULL check in next_resource
Message-ID: <20140922154615.GB5054@roeck-us.net>
References: <1411314704-27072-1-git-send-email-linux@roeck-us.net>
 <20140922145812.GD4250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140922145812.GD4250@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 10:58:12AM -0400, Vivek Goyal wrote:
> On Sun, Sep 21, 2014 at 08:51:44AM -0700, Guenter Roeck wrote:
> > Commit 8c86e70acead ("resource: provide new functions to walk through
> > resources") adds a suble new requirement that iomem_resource.child must
> > not be NULL when walk_system_ram_range is called. This can cause a crash
> > if it turns out that there are no children. The crash ('Unable to handle
> > kernel NULL pointer dereference') is seen when trying to test a crisv32
> > image on kernels with this commit applied.
> > 
> > Fix by adding a NULL check into next_resource().
> > 
> > Fixes: 8c86e70acead ("resource: provide new functions to walk through resources")
> 
> One such problem was solved with following commit.
> 
> commit 800df627e2eabaf4a921d342a1d5162c843b7fc2
> Author: Vivek Goyal <vgoyal@redhat.com>
> Date:   Fri Aug 29 15:18:29 2014 -0700
> 
>     resource: fix the case of null pointer access
> 
> Do you have this patch applied in your tree?
> 
Bisect suggests that I did.

I know what happened: There was another problem that affected crisv32 in
v3.17-rc5, which I tried to bisect. Bisect result pointed to your commit,
but it wasn't the cause of the other problem. As a result, bisect did not
catch the real problem but the NULL pointer problem instead.

Please ignore my patch; I confirmed that commit 800df627e2ea already fixes
the problem I tried to fix.

Thanks,
Guenter
