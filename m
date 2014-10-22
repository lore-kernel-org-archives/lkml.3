Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaJVItw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 04:49:52 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:48545 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754344AbaJVIts (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 04:49:48 -0400
Date: Wed, 22 Oct 2014 01:49:44 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: andrew@lunn.ch, ezequiel.garcia@free-electrons.com, dwmw2@infradead.org,
        jg1.han@samsung.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mtd: orion_nand: fix error code path in probe
Message-ID: <20141022084944.GK16128@brian-ubuntu>
References: <543F4CF0.8080404@free-electrons.com>
 <1413435515-12134-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413435515-12134-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 06:58:35AM +0200, Michael Opdenacker wrote:
> This replaces kzalloc() and ioremap() calls by devm_ functions
> in the probe() routine, which automatically release the corresponding
> resources when probe() fails or when the device is removed.
> 
> This simplifies simplifies the error management code, and brings
> the below improvements or changes:
> 
> A. Fixing a bug reported by "make coccicheck":
> 
> If "board = devm_kzalloc()" fails, the probe() function jumps
> incorrectly to label "no_res" and therefore returns without
> running iounmap().
> 
> B. Requesting the memory region
> 
> Using devm_ioremap_resource() makes the probe() function request
> the corresponding memory region before running ioremap(), as
> it is supposed to do.
> 
> C. Standardizing the error codes:
> 
> The use of devm_ioremap_resource() changes the return value:
>  * -ENOMEM instead of -EIO in case of ioremap() failure,
>  * -EINVAL instead of -ENODEV in case of platform_get_resource()
>    failure.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Pushed to l2-mtd.git. Thanks!

Brian
