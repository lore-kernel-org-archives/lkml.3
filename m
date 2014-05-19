Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932918AbaESURR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 16:17:17 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:63760 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbaESURQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 16:17:16 -0400
Date: Mon, 19 May 2014 16:17:12 -0400
From: Tejun Heo <tj@kernel.org>
To: Eli Billauer <eli.billauer@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] dma-mapping: Add devm_ interface for dma_map_single()
Message-ID: <20140519201712.GD27506@mtj.dyndns.org>
References: <1400228799-8832-1-git-send-email-eli.billauer@gmail.com>
 <1400228799-8832-3-git-send-email-eli.billauer@gmail.com>
 <20140516210805.GO5379@htj.dyndns.org>
 <537753C9.3060101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537753C9.3060101@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eli.

On Sat, May 17, 2014 at 03:19:21PM +0300, Eli Billauer wrote:
> >>+	if (dma_mapping_error(dev, dma_handle)) {
> >>+		devres_free(dr);
> >>+		return 0;
> >Can't we just keep returning dma_handle?  Even if that means invoking
> >->mapping_error() twice?  It's yucky to have subtly different error
> >return especially because in most cases it won't fail.
> Yucky it is indeed. There are however two problems with keeping the existing
> API:
> 
> * What to do if devres_alloc() fails. How do I signal back an error? The
> only way I can think of is returning zero. But if the caller should know
> that zero means failure, I've already broken the API. I might as well return
> zero for any kind of failure.

What can't it just do the following?

	if (dma_mapping_error(dev, dma_handle)) {
		devres_free(dr);
		return dma_handle;
	}

The caller would have to invoke dma_mapping_error() again but is that
a problem?

Thanks.

-- 
tejun
