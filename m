Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaKDHJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 02:09:18 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:12106 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796AbaKDHJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 02:09:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AghSAOF6WFR5LbBUPGdsb2JhbABcgw6BLII2hQezTwaVKIVqAgIBAQKBJhcBAQEBAQYBAQEBODuEAgEBAQQ6HCMQCAMVAwklDwUlAwcaE4hAy2QBAQgCAR8Yhh+KWQeESwWGNZdLgTKDTZNQIIFuKS+CSwEBAQ
Date: Tue, 4 Nov 2014 18:09:08 +1100
From: Dave Chinner <david@fromorbit.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 3.2 019/102] xfs: don't dirty buffers beyond EOF
Message-ID: <20141104070908.GU16186@dastard>
References: <lsq.1414880882.522510247@decadent.org.uk>
 <lsq.1414880883.633041348@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1414880883.633041348@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 10:28:03PM +0000, Ben Hutchings wrote:
> 3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

I'm not sure it's a good idea to pull stuff like this back into
really old stable kernels. This was part of a much larger series of
bug fixes that were fairly carefully tested. I very much doubt that
there is specific XFS test coverage on these older kernels that
would determine if this has introduced problems or not....
> 
> ------------------
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> commit 22e757a49cf010703fcb9c9b4ef793248c39b0c2 upstream.
> 
> generic/263 is failing fsx at this point with a page spanning
> EOF that cannot be invalidated. The operations are:
> 
> 1190 mapwrite   0x52c00 thru    0x5e569 (0xb96a bytes)
> 1191 mapread    0x5c000 thru    0x5d636 (0x1637 bytes)
> 1192 write      0x5b600 thru    0x771ff (0x1bc00 bytes)

I've got no idea whether generic/263 even exposes this problem
on 3.2 kernels, or whether there's a bunch of the other upstream
changes that need to be added first to expose it... :/

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
