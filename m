Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750840AbaGBXJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 19:09:21 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:40703 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbaGBXJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 19:09:20 -0400
Date: Wed, 2 Jul 2014 16:09:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Alexey Dobriyan <adobriyan@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] headers: remove fs.h from poll.h
In-Reply-To: <20140701220642.GA3150@p183.telecom.by>
Message-ID: <alpine.DEB.2.02.1407021605490.5931@chino.kir.corp.google.com>
References: <20140701200150.GA31103@p183.telecom.by> <20140701134338.1d221dd127ffef4c25e86800@linux-foundation.org> <20140701220642.GA3150@p183.telecom.by>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014, Alexey Dobriyan wrote:

> fs.h inclusion is unnecessary because it is only needed
> for "struct file" forward declaration.
> 
> Those fs.h inclusions are fixing inevitable compilation failures.
> There maybe more compilation failures.
> 
> What I did to get 2000 number is:
> * make allmodconfig
> * make
> * touch include/linux/fs.h
> * make
> * [count how many files were rebuilt]
> 
> After more header tweaking the number of files that were rebuilt dropped
> by ~2000 but code still compiles, which means fs.h inclusions were useless.
> 

Lots of #ifdefs in fs.h, I hope your series includes building for all 
possible combinations.

> This is first patch in series. Same thing we did with sched.h earlier.
> 

Is it possible to post the whole series together so it makes sense and 
it's possible to put it through some thorough build testing?  If you can 
point me to a git tree that I can pull, then I can do that on 
infrastructure that I have probably quicker than most.
