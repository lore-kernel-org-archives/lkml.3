Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334Ab3KXMmI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 07:42:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43356 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3KXMmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 07:42:06 -0500
Date: Sun, 24 Nov 2013 12:41:25 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        eric.y.miao@gmail.com, haojian.zhuang@gmail.com,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] ARM: pxa: Move iotable mapping inside vmalloc region
Message-ID: <20131124124125.GM16735@n2100.arm.linux.org.uk>
References: <1385296571-23599-1-git-send-email-ezequiel.garcia@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385296571-23599-1-git-send-email-ezequiel.garcia@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 24, 2013 at 09:36:11AM -0300, Ezequiel Garcia wrote:
> In order to remove the following ugly message:
> 
>   BUG: mapping for 0x00000000 at 0xff000000 out of vmalloc space
> 
> the iotable mappings should be re-located inside the vmalloc
> region. Such move was introduced at commit:
> 
> commit 0536bdf33faff4d940ac094c77998cfac368cfff
> Author: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date:   Thu Aug 25 00:35:59 2011 -0400
> 
>     ARM: move iotable mappings within the vmalloc region
> 
> While at it, let's add some nicer defines to make the code
> more readable.
> 
> Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> Signed-off-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>

NAK.  I'm guessing that you haven't properly tested this.  Grep for
UNCACHED_PHYS_0, and what you'll find is that your change will break
standby and suspend on all PXA platforms.
