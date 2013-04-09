Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935134Ab3DIR40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:56:26 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37826 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab3DIR4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:56:24 -0400
Message-ID: <51645630.3030608@linux.vnet.ibm.com>
Date: Tue, 09 Apr 2013 13:56:00 -0400
From: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Roland Dreier <roland@kernel.org>, qemu-devel@nongnu.org,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com> <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com> <515F3A0F.5030507@linux.vnet.ibm.com> <20130409163929.GA7661@redhat.com>
In-Reply-To: <20130409163929.GA7661@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040917-9360-0000-0000-000011AA0797
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 12:39 PM, Michael S. Tsirkin wrote:
> On Fri, Apr 05, 2013 at 04:54:39PM -0400, Michael R. Hines wrote:
>> To be more specific, here's what I did:
>>
>> 1. apply kernel module patch - re-insert module
>> 1. QEMU does: ibv_reg_mr(........IBV_ACCESS_GIFT | IBV_ACCESS_REMOTE_READ)
>> 2. Start the RDMA migration
>> 3. Migration completes without any errors
>>
>> This test does *not* work with a cgroup swap limit, however. The
>> process gets killed. (Both with and without GIFT)
>>
>> - Michael
> Try to attach a debugger and see where it is when it gets killed?
>

It's killed by cgroups - not a CPU exception.

The same test works fine using TCP migration with cgroups - everything 
is fine there.

The memory that RDMA attempted to register hits some kind of cgroups policy
which results in a kernel message saying that the cgroup swap limit was hit
and then it goes ahead and kills the process altogether.

It's not a QEMU problem - it seems to be a kernel bug.

