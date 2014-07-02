Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbaGBKTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:19:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50929 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753326AbaGBKTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:19:32 -0400
Date: Wed, 2 Jul 2014 11:19:26 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Yang,Wei" <Wei.Yang@windriver.com>
Cc: mroberto@cpti.cetuc.puc-rio.br, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v1] ARM:sa1100: Remove a redundant spin lock
Message-ID: <20140702101925.GE32514@n2100.arm.linux.org.uk>
References: <1404200488-7809-1-git-send-email-Wei.Yang@windriver.com> <53B3CEAC.9080609@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B3CEAC.9080609@windriver.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 05:19:40PM +0800, Yang,Wei wrote:
> Hi Guys,
>
> What about this patch?

The only concern on the face of it is that it removes mutual exclusion
from the pci config write path, where a read-modifiy-write operation is
performed.

However, the PCI code already gives that guarantee (drivers/pci/access.c)
so this should be safe.

As this is fairly old code, it would be useful to know what the motivation
is behind this change.  Is it purely clean up, or is it something that
you've tested, or is this a change that you require for something else?

Thanks.

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
