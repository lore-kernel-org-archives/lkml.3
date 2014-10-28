Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaJ1Awo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 20:52:44 -0400
Received: from ozlabs.org ([103.22.144.67]:45628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752369AbaJ1Awn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 20:52:43 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v4 00/17] linux: towards virtio-1 guest support
In-Reply-To: <1414081380-14623-1-git-send-email-mst@redhat.com>
References: <1414081380-14623-1-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Tue, 28 Oct 2014 11:15:06 +1030
Message-ID: <87sii99g4t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> Based on patches by Cornelia Rusty and others, but
> with an API that should allow better static checking of code,
> and slightly more concervative changes in vring,net and blk.
>
> Based on patches by Cornelia and others, but
> with an API that should allow better static checking of code,
> slightly more concervative changes in vring and drivers,
> and compatibility for existing drivers so that
> this series be applied before all drivers are converted.
>
> virtio drivers now pass sparse without warnings.

That's good!  Some comments:

1) Patch order.  You need to increase feature bits to 64, then define
   VIRTIO_F_VERSION_1, then use it in your __virtio conversion macros.

2) You need to enhance virtio_check_driver_offered_feature to look
   at the legacy bits, too.
   [ Oh, I see you did that in a followup ]

3) virtio_has_feature() is a bit heavy-weight, you probably want to add
   __virtio_has_feature() or just opencode vdev->features & (1ULL <<
   VIRTIO_F_VERSION_1);

Obviously, patch correctness don't matter until we enable the
VIRTIO_F_VERSION_1 feature in a transport.  That's what makes me
nervous, and I'll be waiting for Cornelia's ACK on that, since
it looks like s390 is ready to go?

Thanks,
Rusty.
