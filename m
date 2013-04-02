Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761722Ab3DBQ6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 12:58:03 -0400
Received: from na3sys010aog109.obsmtp.com ([74.125.245.86]:60709 "HELO
	na3sys010aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1760974Ab3DBQ6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 12:58:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130402155104.GA27382@redhat.com>
References: <20130324155153.GA8597@redhat.com> <20130402155104.GA27382@redhat.com>
From: Roland Dreier <roland@kernel.org>
Date: Tue, 2 Apr 2013 09:57:38 -0700
X-Google-Sender-Auth: 4JEiUgVRxFXVvVYiXUBR9Rwq0Lg
Message-ID: <CAL1RGDUe1=Xd1mpNajiLY08fJ+gBKAMDGeX3SVkS+egOQyiCxQ@mail.gmail.com>
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "Michael R. Hines" <mrhines@linux.vnet.ibm.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 8:51 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>> At the moment registering an MR breaks COW.  This breaks memory
>> overcommit for users such as KVM: we have a lot of COW pages, e.g.
>> instances of the zero page or pages shared using KSM.
>>
>> If the application does not care that adapter sees stale data (for
>> example, it tracks writes reregisters and resends), it can use a new
>> IBV_ACCESS_GIFT flag to prevent registration from breaking COW.
>>
>> The semantics are similar to that of SPLICE_F_GIFT thus the name.
>>
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>
> Roland, Michael is yet to test this but could you please
> confirm whether this looks acceptable to you?

The patch itself is reasonable I guess, given the needs of this particular app.

I'm not particularly happy with the name of the flag.  The analogy
with SPLICE_F_GIFT doesn't seem particularly strong and I'm not
convinced even the splice flag name is very understandable.  But in
the RDMA case there's not really any sense in which we're "gifting"
memory to the adapter -- we're just telling the library "please don't
trigger copy-on-write" and it doesn't seem particularly easy for users
to understand that from the flag name.

 - R.
