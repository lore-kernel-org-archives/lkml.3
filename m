Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752659AbaIAVWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 17:22:54 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42423 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaIAVWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 17:22:53 -0400
Date: Mon, 1 Sep 2014 22:22:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
Message-ID: <20140901212250.GJ7996@ZenIV.linux.org.uk>
References: <CACVxJT9FWrGV=LOR11MoK1LEc6b9orDrA1dRAqMiT2Z=OnOQsg@mail.gmail.com>
 <54047A96.1090900@codethink.co.uk>
 <CACVxJT_nkS9evtCd5x6GH3Fiyg+hO+bJCzvz3pgdxsUj+fwQVw@mail.gmail.com>
 <540484FB.1060906@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <540484FB.1060906@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 03:38:51PM +0100, Rob Jones wrote:
> >>kmalloc where it is expected to be a size_t.
> >
> >Which is a mistake too because allocations are never that large.
> 
> Yet.

*raised eyebrow*

You do realize that kmalloc() gives physically contiguous allocation, right?
And refuses to allocate more than KMALLOC_MAX_SIZE, while we are at it.
With allocations anywhere near such range being very heavily discouraged.

There might or might not be point in using size_t for kmalloc() argument,
but "future-proofing" isn't it.
