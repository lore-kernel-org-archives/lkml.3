Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752652AbaILVQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 17:16:22 -0400
Received: from mail-oi0-f49.google.com ([209.85.218.49]:55556 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaILVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 17:16:20 -0400
MIME-Version: 1.0
In-Reply-To: <540F0CD8.9070002@mellanox.com>
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com>
	<5405D2D8.1040700@mellanox.com>
	<CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com>
	<CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com>
	<CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com>
	<540F0CD8.9070002@mellanox.com>
Date: Sat, 13 Sep 2014 00:16:20 +0300
Message-ID: <CAJ3xEMhSZcrN0_nurc=-sUT+KM3vFgAD6XJjjA-eK0-Jyeut0Q@mail.gmail.com>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
From: Or Gerlitz <gerlitz.or@gmail.com>
To: Roland Dreier <roland@kernel.org>
Cc: Latchesar Ionkov <lionkov@lanl.gov>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Haggai Eran <haggaie@mellanox.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 9, 2014, Haggai Eran <haggaie@mellanox.com> wrote:
> On 04/09/2014, Roland Dreier wrote:

>> Have you done any review or testing of these changes?  If so can you
>> share the results?

> We have tested this feature thoroughly inside Mellanox. We ran random
> tests that performed MR registrations, memory mappings and unmappings,
> calls to madvise with MADV_DONTNEED for invalidations, sending and
> receiving of data, and RDMA operations. The test validated the integrity
> of the data, and we verified the integrity of kernel memory by running
> the tests under a debugging kernel.

Hi Roland,

Per your request we provided the information on tests conducted with
the patches.

Note that the patches can't really disrupt existing applications that
don't set the new IB_ACCESS_ON_DEMAND MR flag when they register
memory. Also
the whole set of changes to the umem area is dependent on building with
CONFIG_INFINIBAND_ON_DEMAND_PAGING -- all in all, everything is in
place for protecting against potential regression that this series
could introduce.

As you didn't provide any feedback for > six months, and we have all
the above in place (report on stability tests, performance data and
mechanics to avoid regressions) I think it would be fair to get this
picked for the coming merge window, thoughts?

Or.
