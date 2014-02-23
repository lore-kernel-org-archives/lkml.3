Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369AbaBWQMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Feb 2014 11:12:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46432 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751158AbaBWQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Feb 2014 11:12:03 -0500
Date: Sun, 23 Feb 2014 16:11:59 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: gregkh@linuxfoundation.org, sameo@linux.intel.com, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/3] regmap: Add API call apply but not register a
	patch file
Message-ID: <20140223161159.GA5901@opensource.wolfsonmicro.com>
References: <1393011432-28909-1-git-send-email-ckeepax@opensource.wolfsonmicro.com> <1393011432-28909-2-git-send-email-ckeepax@opensource.wolfsonmicro.com> <20140222021048.GH25940@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140222021048.GH25940@sirena.org.uk>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 22, 2014 at 11:10:48AM +0900, Mark Brown wrote:
> On Fri, Feb 21, 2014 at 07:37:11PM +0000, Charles Keepax wrote:
> > This patch provides a new regmap API call that allows a patch to be
> > applied but not registered with the regmap core. Common code between
> > this and the existing regmap_register_patch function is factored out to
> > reduce duplication.
> 
> This is just regmap_multi_reg_write() I think?  That already exists, the
> theory was that we're going to get an optimised version of that for some
> hardware which can stream things and cut out some overheads though that
> doesn't seem to have materialised yet.

I had missed regmap_multi_reg_write but the difference here is that we
apply cache bypass, and that the cache bypass is only applied whilst the
regmap lock is held. This allows users to be sure that no writes
from other threads will accidentally have the bypass applied to them.

Thanks,
Charles
