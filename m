Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162725Ab3DEUyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:54:46 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35947 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162068Ab3DEUyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:54:45 -0400
Message-ID: <515F3A0F.5030507@linux.vnet.ibm.com>
Date: Fri, 05 Apr 2013 16:54:39 -0400
From: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Roland Dreier <roland@kernel.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com> <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
In-Reply-To: <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040520-5406-0000-0000-0000072A2FF7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To be more specific, here's what I did:

1. apply kernel module patch - re-insert module
1. QEMU does: ibv_reg_mr(........IBV_ACCESS_GIFT | IBV_ACCESS_REMOTE_READ)
2. Start the RDMA migration
3. Migration completes without any errors

This test does *not* work with a cgroup swap limit, however. The process 
gets killed. (Both with and without GIFT)

- Michael

On 04/05/2013 04:43 PM, Roland Dreier wrote:
> On Fri, Apr 5, 2013 at 1:17 PM, Michael R. Hines
> <mrhines@linux.vnet.ibm.com> wrote:
>> I also removed the IBV_*_WRITE flags on the sender-side and activated
>> cgroups with the "memory.memsw.limit_in_bytes" activated and the migration
>> with RDMA also succeeded without any problems (both with *and* without GIFT
>> also worked).
> Not sure I'm interpreting this correctly.  Are you saying that things
> worked without actually setting the GIFT flag?   In which case why are
> we adding this flag?
>
>   - R.
>

