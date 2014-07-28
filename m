Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaG1SPZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 14:15:25 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:45828 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151AbaG1SPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 14:15:23 -0400
Date: Mon, 28 Jul 2014 19:14:56 +0100
From: Will Deacon <will.deacon@arm.com>
To: Konstantin Khlebnikov <k.khlebnikov@samsung.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: Re: [PATCH 2/2] ARM: LPAE: reduce damage caused by idmap to virtual
 memory layout
Message-ID: <20140728181456.GO15536@arm.com>
References: <20140722153623.25088.37742.stgit@buzz>
 <20140722153635.25088.14197.stgit@buzz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722153635.25088.14197.stgit@buzz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 04:36:35PM +0100, Konstantin Khlebnikov wrote:
> idmap layout combines both phisical and virtual addresses.
> Everything works fine if ram physically lays below PAGE_OFFSET.
> Otherwise idmap starts punching huge holes in virtual memory layout.
> It maps ram by 2MiB sections, but when it allocates new pmd page it
> cuts 1GiB at once.
> 
> This patch makes a copy of all affected pmds from init_mm.
> Only few (usually one) 2MiB sections will be lost.
> This is not eliminates problem but makes it 512 times less likely.

I'm struggling to understand your commit message, but making a problem `512
times less likely' does sound like a bit of a hack to me. Can't we fix this
properly instead?

Will
