Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab3AXVkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:40:07 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:54690 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3AXVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:40:02 -0500
Date: Thu, 24 Jan 2013 13:39:58 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, Hillf Danton <dhillf@gmail.com>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, zab@zabbo.net, linux-fsdevel@vger.kernel.org
Subject: Re: next-20130117 - kernel BUG with aio
Message-ID: <20130124213958.GJ26407@google.com>
References: <3544.1358774694@turing-police.cc.vt.edu>
 <CAJd=RBBBbv07aoOTF=PNy1FpCyuRV7fnQEGX_DXEYFSSknKtqQ@mail.gmail.com>
 <2553.1358890098@turing-police.cc.vt.edu>
 <CAJd=RBCHRDzyjY_hOZCj6rHBXzb3f5wWxdqXYuLbQXLe2n4JeA@mail.gmail.com>
 <13450.1359048141@turing-police.cc.vt.edu>
 <20130124211850.GH26407@google.com>
 <20130124132759.c892fb4c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130124132759.c892fb4c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 01:27:59PM -0800, Andrew Morton wrote:
> On Thu, 24 Jan 2013 13:18:50 -0800
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > So, Andrew - that "smoosh struct kiocb" patch should just be dropped,
> > even if I fixed that issue clearly the idea is a lot less safe than I
> > thought. I've got patches for the other stuff I'm going to mail out
> > momentarily.
> 
> Dropped.  Do you expect that this will fix everything?

No, I didn't see that bug until after I'd fixed the other three, but as
far as I can tell everything's fixed with the patches I'm about to mail
out - my test VM has been running for the past two days without errors,
it's kill -9'ing a process that's got iocbs in flight to a loopback
device every two seconds.

> Please cc linux-fsdevel on the aio stuff - I'm seeing some AIO things
> over there which aren't cc'ed to lkml or linux-aio.

Will do

> Please also take a look at Jan's recent
> http://www.spinics.net/lists/linux-fsdevel/msg61738.html and have a
> think about how this plays with your patchset.

Oh fun, I've chased a bug or two in that ext4 code, that stuff's
scary... I'm sure it'll take me a bit to wrap my head around what's
going on there but I'm looking at it now.
