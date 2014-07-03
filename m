Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbaGCT75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 15:59:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:27263 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbaGCT74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 15:59:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,596,1400050800"; 
   d="scan'208";a="557162580"
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 30/50] mars: add new file drivers/block/mars/xio_bricks/xio_aio.c
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de>
	<1404251250-22992-31-git-send-email-tst@schoebel-theuer.de>
Date: Thu, 03 Jul 2014 12:59:52 -0700
In-Reply-To: <1404251250-22992-31-git-send-email-tst@schoebel-theuer.de>
	(Thomas Schoebel-Theuer's message of "Tue, 1 Jul 2014 23:47:10 +0200")
Message-ID: <87bnt6tdqf.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Schoebel-Theuer <tst@schoebel-theuer.de> writes:
> +
> +/************************ mmu faking (provisionary) ***********************/
> +
> +/* Kludge: our kernel threads will have no mm context, but need one
> + * for stuff like ioctx_alloc() / aio_setup_ring() etc
> + * which expect userspace resources.
> + * We fake one.
> + * TODO: factor out the userspace stuff from AIO such that
> + * this fake is no longer necessary.
> + * Even better: replace do_mmap() in AIO stuff by something
> + * more friendly to kernelspace apps.
> + */

That obviously has to be done before taking this patchkit any further.

AFAIK the kernel already has totally usable internal AIO interfaces.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
