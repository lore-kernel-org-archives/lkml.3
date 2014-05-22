Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754460AbaEVJwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 05:52:34 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:51743 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbaEVJwc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 05:52:32 -0400
Date: Thu, 22 May 2014 11:52:27 +0200
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Daniel Phillips <daniel@phunq.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        tux3@tux3.org, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] Tux3 for review
Message-ID: <20140522095227.GA9176@gmail.com>
References: <5376B273.7000800@partner.samsung.com>
 <20140518235555.GC18954@dastard>
 <537AA802.408@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537AA802.408@phunq.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 19.05.2014 17:55, Daniel Phillips wrote:
> On 05/18/2014 04:55 PM, Dave Chinner wrote:
> >On Fri, May 16, 2014 at 05:50:59PM -0700, Daniel Phillips wrote:
> >>We would like to offer Tux3 for review for mainline merge. We have
> >>prepared a new repository suitable for pulling:
> >>
> >>https://git.kernel.org/cgit/linux/kernel/git/daniel/linux-tux3.git/

First of all, thank you for trying to merge it to mainline.
Maybe I cannot say the code is clean enough, but basically
the filesystem seems to work at least.

> >Then there's all the writeback hacks. You've simply copy-n-pasted
> >most of fs-writeback.c, including duplicating structures like struct
> >wb_writeback_work and then hacked in crap (kallsyms lookups!) to be
> >able to access core structures from kernel module context
> >(tux3_setup_writeback(), I'm looking at you).
> This is intentional. The files named "*_hack" were kept as close as
> possible to the original core code to clarify exactly where core
> needs to change in order to remove our workarounds. If you think we
> should pretty up that code then we will happily do it. Or maybe we
> can hammer out acceptable core patches right now, and include those
> with our merge proposal. That would make us even happier. We hate
> those hacks as much as you do.

Looking up kallsyms is not only hacky, but also making the filesystem
unable to be mounted at all, when CONFIG_KALLSYMS_ALL is not defined.
I'll send out patches to fix that separately to tux3 mailing list.

Regards,
Dongsu

