Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaIJIwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:52:32 -0400
Received: from eu1sys200aog132.obsmtp.com ([207.126.144.207]:40352 "EHLO
	eu1sys200aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751320AbaIJIwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:52:02 -0400
Message-ID: <54101123.2080208@mellanox.com>
Date: Wed, 10 Sep 2014 11:51:47 +0300
From: Haggai Eran <haggaie@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>, Latchesar Ionkov <lionkov@lanl.gov>
CC: Or Gerlitz <gerlitz.or@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sagi Grimberg <sagig@mellanox.com>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 for-next 00/16] On demand paging
References: <1404377069-20585-1-git-send-email-haggaie@mellanox.com> <5405D2D8.1040700@mellanox.com> <CAJ3xEMj8BJLJvetNoqGOFhqeJHupEd=kbnFeO_Na=1ZYbvBk9g@mail.gmail.com> <CAOha14xthZHSpS_T+XRgZcPqwaZvtMw0iGTzKjTyjdBuLhJ4Eg@mail.gmail.com> <CAG4TOxO54LJgSjFFDge4X9OpaBNrM1z=iGSV0GEY+0iFFSs9sw@mail.gmail.com> <540F0CD8.9070002@mellanox.com>
In-Reply-To: <540F0CD8.9070002@mellanox.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.8.3.227]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 17:21, Haggai Eran wrote:
> On 04/09/2014 00:15, Roland Dreier wrote:
>> Have you done any review or testing of these changes?  If so can you
>> share the results?
> 
> We have tested this feature thoroughly inside Mellanox. We ran random
> tests that performed MR registrations, memory mappings and unmappings,
> calls to madvise with MADV_DONTNEED for invalidations, sending and
> receiving of data, and RDMA operations. The test validated the integrity
> of the data, and we verified the integrity of kernel memory by running
> the tests under a debugging kernel.

We wanted to add regarding performance testing of these patches, we have
tested ODP on several setups, including low-level RDMA micro-benchmarks,
MPI applications, and iSER. In all cases, ODP delivers the *same*
bare-metal performance as obtained with standard MRs, in terms of both
BW and latency. In addition, performance of standard MRs is not affected
by the presence of ODP applications.

The main benefits of ODP is the simplified programming model, simplified
management, and avoiding worst-case memory commitment.
For example, we were able to run multiple concurrent instances of iSER
targets, allowing over-commitment that otherwise wouldn’t be possible.
In the MPI case, both IMB (Pallas) and applications achieved the same
performance as the pin-down cache, with minimal memory locking
privileges while avoiding any glibc hooks for detecting invalidations.

Regards,
Haggai
