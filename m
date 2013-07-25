Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab3GYR4B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 13:56:01 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44544 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757676Ab3GYRzz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 13:55:55 -0400
Date: Thu, 25 Jul 2013 19:55:42 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] tile: support PTP using the tilegx mPIPE (IEEE 1588)
Message-ID: <20130725175542.GD4619@netboy>
References: <20130724062533.GA5163@netboy>
 <cover.1374609948.git.cmetcalf@tilera.com>
 <77f753af79722f39c5fa77cd35adefdd1634e5d5.1374609949.git.cmetcalf@tilera.com>
 <201307251525.r6PFP7Ox030354@farm-0012.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201307251525.r6PFP7Ox030354@farm-0012.internal.tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 11:19:38AM -0400, Chris Metcalf wrote:
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> v2:
>  - Moved Kconfig stanza to drivers/ethernet/tile/Kconfig
>  - Clarify minimum and maximum frequency adjustments

So if the requested frequency adjustment lies within the +/-30 ppm
interval, then you return EINVAL? Maybe ERANGE would be better.
Perhaps the driver should just round to the closest value it can
support? Unfortunately, we don't have a way to communicate this kind
of limitation to user space.

>  - Merge PTP support into tilegx.c driver source code directly
>  - Support SIOCSHWTSTAMP ioctl appopriately
>  - Rebased to be the last patch in the series to simplify development

Anyhow, this looks much better to me now.

Acked-by: Richard Cochran <richardcochran@gmail.com>
