Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162678Ab3DEVck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 17:32:40 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59059 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162305Ab3DEVci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 17:32:38 -0400
Message-ID: <515F42EE.8060203@linux.vnet.ibm.com>
Date: Fri, 05 Apr 2013 17:32:30 -0400
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
References: <20130324155153.GA8597@redhat.com> <515F3160.4020007@linux.vnet.ibm.com> <CAL1RGDU2jtrRrxi6srsH_ADiYGvJbCpCT3UvoLGTX3cvQ=s0kQ@mail.gmail.com> <515F3948.40205@linux.vnet.ibm.com> <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
In-Reply-To: <CAG4TOxPNHZadLjq6-HuOExf1XXLO6AYyvRQ1L09i6qVeA5dbLQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040521-7606-0000-0000-00000A255738
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I have the "is_dup_page()" commented out.......when RDMA is 
activated.....

Is there something else in QEMU that could be touching the page that I 
don't know about?

- Michael


On 04/05/2013 05:03 PM, Roland Dreier wrote:
> On Fri, Apr 5, 2013 at 1:51 PM, Michael R. Hines
> <mrhines@linux.vnet.ibm.com> wrote:
>> Sorry, I was wrong. ignore the comments about cgroups. That's still broken.
>> (i.e. trying to register RDMA memory while using a cgroup swap limit cause
>> the process get killed).
>>
>> But the GIFT flag patch works (my understanding is that GIFT flag allows the
>> adapter to transmit stale memory information, it does not have anything to
>> do with cgroups specifically).
> The point of the GIFT patch is to avoid triggering copy-on-write so
> that memory doesn't blow up during migration.  If that doesn't work
> then there's no point to the patch.
>
>   - R.
>

