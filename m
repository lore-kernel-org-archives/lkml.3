Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbaCALP3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 06:15:29 -0500
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:52096 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460AbaCALP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 06:15:27 -0500
Message-ID: <5311C142.6040509@de.ibm.com>
Date: Sat, 01 Mar 2014 12:15:14 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: vyasevic@redhat.com
CC: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        KVM list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: macvtap performance regression (bisected) between 3.13 and 3.14-rc1
References: <530FA586.3010400@de.ibm.com> <53110A62.7070109@redhat.com>
In-Reply-To: <53110A62.7070109@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14030111-3548-0000-0000-00000841418E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/02/14 23:14, Vlad Yasevich wrote:
> On 02/27/2014 03:52 PM, Christian Borntraeger wrote:
>> Vlad,
>>
>> commit 6acf54f1cf0a6747bac9fea26f34cfc5a9029523
>>     macvtap: Add support of packet capture on macvtap device.
>>
>> causes a performance regression for iperf traffic between two KVM guests
>> on my s390 system. Both guests are connected via two macvtaps on the same OSA
>> network card.
>> Before that patch I get ~20 Gbit/sec between two guests, afterwards I get
>> ~4Gbit/sec
>>
>> Latency seems to be unchanges (uperf 1byte ping pong).
>>
>> According to ifconfig in the guest, I have ~ 1500 bytes per packet with this
>> patch and ~  40000 bytes without. So for some reason this patch causes the
>> network stack to do segmentation. (the guest kernel stays the same, only host 
>> kernel is changed).
>>
>> Any ideas?
> 
> I am looking.  It shouldn't cause addition segmentations and when I ran
> netperf on the code I didn't see any difference in the throughput.

Dont know if the different bytes/packets ratio is really the reason or
just a side effect. As a hint: the underlying network device does not support
segmentation, but this should not matter for traffic between to guests.

Maybe you remember, we had a similar situation with commit 3e4f8b787370978733ca6cae452720a4f0c296b8
(macvtap: Perform GSO on forwarding path), the setup is basically the same.


Christian

