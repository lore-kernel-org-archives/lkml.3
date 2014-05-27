Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaE0EDb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 00:03:31 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:64728 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaE0EDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 00:03:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com>
References: <20140526194347.GB2271@dhcp-27-189.brq.redhat.com>
Date: Tue, 27 May 2014 12:03:29 +0800
Message-ID: <CACVXFVOaF-EOioE38sy9=2f-+rKECJnzUCSHrL-VZJi1Ycj_wA@mail.gmail.com>
Subject: Re: [jet.chen@intel.com: [bio] kernel BUG at drivers/block/virtio_blk.c:166!]
From: Ming Lei <tom.leiming@gmail.com>
To: Maurizio Lombardi <mlombard@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, jet.chen@intel.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Fengguang Wu <fengguang.wu@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 3:43 AM, Maurizio Lombardi <mlombard@redhat.com> wrote:
> Hi Jens,
>
> looks like that commit 3979ef4dcf3d1de55a560a3a4016c30a835df44d ("bio-modify-__bio_add_page-to-accept-pages-that-dont-start-a-new-segment-v3")
> introduces a regression, as reported by Jet Chan.
>
> Do you have any idea about the possible problem with this patch?
>
> it is the one that performs a recount of the segments in case of failure in __bio_add_page()
>
> http://www.spinics.net/lists/mm-commits/msg103684.html
>
> I would not be surprised if the bug was introduced by fceb38f36f, because it
> contained a mystake that commit 3979ef4dcf supposedly fixed.
> But learning that commit 3979ef4dcf is introducing a regression leaves
> me quite puzzled.

>From code of __blk_recalc_rq_segments(), looks it
won't check if recounted physical segment number is
bigger than queue_max_segments(), so wondering if
blk_recount_segments() can always decrease
physical segment number.

Thanks,
--
Ming Lei
