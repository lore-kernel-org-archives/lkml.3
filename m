Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153Ab3DJEck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:32:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:58672 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab3DJEci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:32:38 -0400
Message-ID: <5164EB5F.80403@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 00:32:31 -0400
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
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com> <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com> <515F3948.40205@linux.vnet.ibm.com> <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com> <515F42EE.8060203@linux.vnet.ibm.com> <20130409190350.GB8212@redhat.com> <5164BFE3.4040204@linux.vnet.ibm.com> <20130410032449.GA12777@redhat.com>
In-Reply-To: <20130410032449.GA12777@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041004-3620-0000-0000-000001F80B33
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2013 11:24 PM, Michael S. Tsirkin wrote:
> Which mechanism do you refer to? You patches still seem to pin each 
> page in guest memory at some point, which will break all COW. In 
> particular any pagemap tricks to detect duplicates on source that I 
> suggested won't work. 

Sorry, I mispoke. I'm reffering to dynamic server page registration.

Of course it does not eliminate pinning - but it does mitigate the foot 
print of the VM as a feature that was requested.

I have implemented it and documented it.

- Michael

>> On 04/09/2013 03:03 PM, Michael S. Tsirkin wrote:
>>> presumably is_dup_page reads the page, so should not break COW ...
>>>
>>> I'm not sure about the cgroups swap limit - you might have
>>> too many non COW pages so attempting to fault them all in
>>> makes you exceed the limit. You really should look at
>>> what is going on in the pagemap, to see if there's
>>> measureable gain from the patch.
>>>
>>>
>>> On Fri, Apr 05, 2013 at 05:32:30PM -0400, Michael R. Hines wrote:
>>>> Well, I have the "is_dup_page()" commented out.......when RDMA is
>>>> activated.....
>>>>
>>>> Is there something else in QEMU that could be touching the page that
>>>> I don't know about?
>>>>
>>>> - Michael
>>>>
>>>>
>>>> On 04/05/2013 05:03 PM, Roland Dreier wrote:
>>>>> On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
>>>>> <mrhines@linux.vnet.ibm.com> wrote:
>>>>>> Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
>>>>>> (i.e. trying to register RDMA memory while using a cgroup swap limit cause
>>>>>> the process get killed).
>>>>>>
>>>>>> But the GIFT flag patch works (my understanding is that GIFT flag allows the
>>>>>> adapter to transmit stale memory information, it does not have anything to
>>>>>> do with cgroups specifically).
>>>>> The point of the GIFT patch is to avoid triggering copy-on-write so
>>>>> that memory doesn't blow up during migration.  If that doesn't work
>>>>> then there's no point to the patch.
>>>>>
>>>>>   - R.
>>>>>

