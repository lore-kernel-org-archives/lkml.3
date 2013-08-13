Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039Ab3HMQmA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:42:00 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:54570 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab3HMQl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 12:41:58 -0400
Message-ID: <1376412116.24869.3.camel@bobble.lax.corp.google.com>
Subject: Re: [PATCH] dm: Make MIN_IOS, et al, tunable via sysctl.
From: Frank Mayhar <fmayhar@google.com>
To: linux-kernel@vger.kernel.org
Date: Tue, 13 Aug 2013 09:41:56 -0700
In-Reply-To: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
References: <1376070533.26057.244.camel@bobble.lax.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping?  Has anyone glanced at this?

On Fri, 2013-08-09 at 10:48 -0700, Frank Mayhar wrote:
> The device mapper and some of its modules allocate memory pools at
> various points when setting up a device.  In some cases, these pools are
> fairly large, for example the multipath module allocates a 256-entry
> pool and the dm itself allocates three of that size.  In a
> memory-constrained environment where we're creating a lot of these
> devices, the memory use can quickly become significant.  Unfortunately,
> there's currently no way to change the size of the pools other than by
> changing a constant and rebuilding the kernel.
> 
> This patch fixes that by changing the hardcoded MIN_IOS (and certain
> other) #defines in dm-crypt, dm-io, dm-mpath, dm-snap and dm itself to
> sysctl-modifiable values.  This lets us change the size of these pools
> on the fly, we can reduce the size of the pools and reduce memory
> pressure.
> 
> We tested performance of dm-mpath with smaller MIN_IOS sizes for both dm
> and dm-mpath, from a value of 32 all the way down to zero.  Bearing in
> mind that the underlying devices were network-based, we saw essentially
> no performance degradation; if there was any, it was down in the noise.
> One might wonder why these sizes are the way they are; I investigated
> and they've been unchanged since at least 2006.
> 
> Signed-off-by: Frank Mayhar <fmayhar@google.com>


-- 
Frank Mayhar
310-460-4042

