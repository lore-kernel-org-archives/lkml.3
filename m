Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3ARBhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 20:37:47 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41946 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3ARBhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:37:46 -0500
Date: Thu, 17 Jan 2013 17:37:43 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: avoid use after free of a pinctrl context
 pointer
Message-ID: <20130118013743.GA7605@kroah.com>
References: <Pine.LNX.4.64.1301161720440.19928@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1301161720440.19928@axis700.grange>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 05:22:34PM +0100, Guennadi Liakhovetski wrote:
> During probing, pinctrl context is allocated and assigned to the struct
> device::pins pointer. If probing fails or if the driver is later unbound
> and re-probed again, the memory is freed, but the pointer is not cleared.
> On a repeated probing attempt a non-NULL pointer indicates an already
> allocated context, which then gets used. To avoid this the pointer must
> be cleared.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  drivers/base/dd.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)

This can't go through my tree, as it breaks the build.  Please send it
to whereever the pinctrl code is coming from.

thanks,

greg k-h
