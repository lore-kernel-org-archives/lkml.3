Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750731Ab3IXEMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 00:12:13 -0400
Received: from mga14.intel.com ([143.182.124.37]:5001 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702Ab3IXEML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 00:12:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,968,1371106800"; 
   d="scan'208";a="298541864"
From: Andi Kleen <andi@firstfloor.org>
To: Marcelo Sousa <marceloabsousa@gmail.com>
Cc: linux-kernel@vger.kernel.org, msousa@cs.ox.ac.uk
Subject: Re: Lightweight type analysis for memory safety through verification of API uses
References: <CACu8kRTN7XoTxvcFHQ=7N-rUGoUePS43EwRKax25mqBjzEXNVg@mail.gmail.com>
Date: Mon, 23 Sep 2013 21:11:45 -0700
In-Reply-To: <CACu8kRTN7XoTxvcFHQ=7N-rUGoUePS43EwRKax25mqBjzEXNVg@mail.gmail.com>
	(Marcelo Sousa's message of "Tue, 17 Sep 2013 14:00:48 +0100")
Message-ID: <87fvsudfjy.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marcelo Sousa <marceloabsousa@gmail.com> writes:

> I've designed and implemented a tool similar to sparse and CQUAL that
> does type inference of user specified type qualifiers, e.g. iomem. It
> receives an API specification with the type qualifiers and also a
> partial order, e.g. IOAddr is not compatible with KernelAddr and
> ioremap returns a pointer to IOAddr while __kmalloc returns a pointer
> to a KernelAddr.

Tracking iomem is ultimatively not very interesting, as in many common
architectures it's just a normal pointer.

__user is much more interesting, as that is real security bugs.
You can probably find some in standard security advisories.

Really interesting would be static lock set tracking for pointers
and similar.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
