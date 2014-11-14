Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaKNIU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 03:20:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54310 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbaKNIU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 03:20:57 -0500
Message-ID: <1415953238.4534.2.camel@linux-t7sj.site>
Subject: Re: [PATCH] mm: fix overly aggressive shmdt() when calls span
 multiple segments
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Hansen <dave@sr71.net>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, dave.hansen@linux.intel.com
Date: Fri, 14 Nov 2014 00:20:38 -0800
In-Reply-To: <20141104000633.F35632C6@viggo.jf.intel.com>
References: <20141104000633.F35632C6@viggo.jf.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-11-03 at 16:06 -0800, Dave Hansen wrote:
> From: Dave Hansen <dave.hansen@linux.intel.com>
> 
> This is a highly-contrived scenario.  But, a single shmdt() call
> can be induced in to unmapping memory from mulitple shm segments.
> Example code is here:
> 
> 	http://www.sr71.net/~dave/intel/shmfun.c
> 
> The fix is pretty simple:  Record the 'struct file' for the first
> VMA we encounter and then stick to it.  Decline to unmap anything
> not from the same file and thus the same segment.
> 
> I found this by inspection and the odds of anyone hitting this in
> practice are pretty darn small.
> 
> Lightly tested, but it's a pretty small patch.

Passed shmdt ltp tests, fwiw.

> Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

