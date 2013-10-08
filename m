Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3JHIGP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 04:06:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:12116 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab3JHIGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 04:06:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1055,1371106800"; 
   d="scan'208";a="407076073"
Date: Tue, 8 Oct 2013 16:06:04 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, gthelen@google.com,
        Dave Anderson <anderson@redhat.com>
Subject: Re: mm: Export 'pageflag_names' array
Message-ID: <20131008080604.GA4820@localhost>
References: <CAOMFOmWbvLCM=a2n_ojnWVeeyvMg=v1T03Q44q-q4jgR7sH+DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOMFOmWbvLCM=a2n_ojnWVeeyvMg=v1T03Q44q-q4jgR7sH+DA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anatol,

On Mon, Oct 07, 2013 at 10:53:32AM -0700, Anatol Pomozov wrote:
> Hi Wu
> 
> I have a request wrt your old commit 718a38211.
> 
> I think it makes sense to export array pageflag_names so kernel dump
> debug tools (like 'crash') can use it as well. Currently the tool
> hard-codes flag names but it is suboptimal as flags are different for
> different configs.
> 
> What do you think? (I can send a patch if you are ok).

I wonder if the KPF_* defined in

        include/uapi/linux/kernel-page-flags.h

fit your needs. These are kernel page flags exported to the user space
and will be maintained stable and immune to kconfig changes. You can
find use examples of them in

        fs/proc/page.c
        tools/vm/page-types.c

Thanks,
Fengguang
