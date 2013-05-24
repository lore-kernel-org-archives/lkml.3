Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615Ab3EXPkL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 11:40:11 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:48091 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab3EXPkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 11:40:10 -0400
Message-ID: <519F89D7.3000009@wwwdotorg.org>
Date: Fri, 24 May 2013 09:40:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Make regmap-mmio usable from atomic contexts
References: <1369384162-25196-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1369384162-25196-1-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/2013 02:29 AM, Lars-Peter Clausen wrote:
> regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.
> To be able to use the regmap API from different contexts (atomic vs non-atomic),
> without the risk of race conditions, we need to use spin_lock_irqsave() and
> spin_lock_irqrestore() instead. A new field, the spinlock_flags field, is added
> to regmap struct to store the flags between regmap_{,un}lock_spinlock(). The
> spinlock_flags field itself is also protected by the spinlock.

Reviewed-by: Stephen Warren <swarren@nvidia.com>
