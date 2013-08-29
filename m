Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755531Ab3H2GCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 02:02:03 -0400
Received: from smtp-fw-33001.amazon.com ([207.171.189.228]:59210 "EHLO
	smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032Ab3H2GCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 02:02:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,981,1367971200"; 
   d="scan'208";a="607704476"
Date: Wed, 28 Aug 2013 23:01:53 -0700
From: Matt Wilson <msw@amazon.com>
To: Prarit Bhargava <prarit@redhat.com>
CC: <linux-kernel@vger.kernel.org>, Clemens Ladisch <clemens@ladisch.de>
Subject: Re: [PATCH] hpet, allow user controlled mmap for user processes
Message-ID: <20130829060151.GA7439@u109add4315675089e695.ant.amazon.com>
References: <51487B59.6010607@ladisch.de>
 <1363959174-28999-1-git-send-email-prarit@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363959174-28999-1-git-send-email-prarit@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 09:32:54AM -0400, Prarit Bhargava wrote:
> The CONFIG_HPET_MMAP Kconfig option exposes the memory map of the HPET
> registers to userspace.  The Kconfig help points out that in some cases this
> can be a security risk as some systems may erroneously configure the map such
> that additional data is exposed to userspace.
> 
> This is a problem for distributions -- some users want the MMAP functionality
> but it comes with a significant security risk.  In an effort to mitigate this
> risk, and due to the low number of users of the MMAP functionality, I've
> introduced a kernel parameter, hpet_mmap_enable, that is required in order
> to actually have the HPET MMAP exposed.
> 
> [v2]: Clemens suggested modifying the Kconfig help text and making the
> default setting configurable.
> [v3]: Fixed up Documentation and Kconfig entries, default now "Y"
> [v4]: After testing, found that I need to modify CONFIG_HPET_MMAP_DEFAULT usage
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Clemens Ladisch <clemens@ladisch.de>
> ---
>  Documentation/kernel-parameters.txt |    4 ++++
>  drivers/char/Kconfig                |    9 +++++++--
>  drivers/char/hpet.c                 |   25 +++++++++++++++++++++++--
>  3 files changed, 34 insertions(+), 4 deletions(-)

It doesn't seem like this patch got picked up and seems like a good
idea to me. Clemens, what do you think?

Acked-by: Matt Wilson <msw@amazon.com>

--msw
