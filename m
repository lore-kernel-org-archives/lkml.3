Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933921Ab3DBWRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:17:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:39562 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873Ab3DBWRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:17:14 -0400
Message-ID: <515B58E5.9070808@linux.vnet.ibm.com>
Date: Tue, 02 Apr 2013 18:17:09 -0400
From: "Michael R. Hines" <mrhines@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Roland Dreier <roland@kernel.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Yishai Hadas <yishaih@mellanox.com>, Christoph Lameter <cl@linux.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, qemu-devel@nongnu.org
Subject: Re: [PATCHv2] rdma: add a new IB_ACCESS_GIFT flag
References: <20130324155153.GA8597@redhat.com> <20130402155104.GA27382@redhat.com> <CAL1RGDUe1=Xd1mpNajiLY08fJ+gBKAMDGeX3SVkS+egOQyiCxQ@mail.gmail.com> <20130402170521.GA30295@redhat.com>
In-Reply-To: <20130402170521.GA30295@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040222-7182-0000-0000-0000060E8A5E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting around to it, Michael, I promise =).

Just came back from vacation.

I have to re-build the ib_ucm kernel module from the original SUSE 
kernel that I'm using along before I can test it......

The machines I'm using are slightly tied up with other things, so its 
taking me a little time to prepare to apply the patch and test the new 
kernel module...

- Michael

On 04/02/2013 01:05 PM, Michael S. Tsirkin wrote:
> On Tue, Apr 02, 2013 at 09:57:38AM -0700, Roland Dreier wrote:
>> On Tue, Apr 2, 2013 at 8:51 AM, Michael S. Tsirkin <mst@redhat.com> wrote:
>>>> At the moment registering an MR breaks COW.  This breaks memory
>>>> overcommit for users such as KVM: we have a lot of COW pages, e.g.
>>>> instances of the zero page or pages shared using KSM.
>>>>
>>>> If the application does not care that adapter sees stale data (for
>>>> example, it tracks writes reregisters and resends), it can use a new
>>>> IBV_ACCESS_GIFT flag to prevent registration from breaking COW.
>>>>
>>>> The semantics are similar to that of SPLICE_F_GIFT thus the name.
>>>>
>>>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>>> Roland, Michael is yet to test this but could you please
>>> confirm whether this looks acceptable to you?
>> The patch itself is reasonable I guess, given the needs of this particular app.
>>
>> I'm not particularly happy with the name of the flag.  The analogy
>> with SPLICE_F_GIFT doesn't seem particularly strong and I'm not
>> convinced even the splice flag name is very understandable.  But in
>> the RDMA case there's not really any sense in which we're "gifting"
>> memory to the adapter -- we're just telling the library "please don't
>> trigger copy-on-write" and it doesn't seem particularly easy for users
>> to understand that from the flag name.
>>
>>   - R.
> The point really is that any writes by application
> won't be seen until re-registration, right?
> OK, what's a better name?  IBV_ACCESS_NON_COHERENT?
> Please tell me what is preferable and we'll go ahead with it.
>

