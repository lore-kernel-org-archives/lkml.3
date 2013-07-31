Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843Ab3GaUm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 16:42:59 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:52647 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab3GaUm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 16:42:57 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo5GUTXyo4GeCGvh_GauKUA4decbDWUnD47qKPr6E65g9w@mail.gmail.com>
References: <1360036520-31032-1-git-send-email-wangyijing@huawei.com>
 <51A42137.9090908@huawei.com> <CAErSpo7iyiq6H-BsPNO0Nyc1SF+JteOzBqNQ+d_D=RYE_pdTEA@mail.gmail.com>
 <51F73108.4070905@huawei.com> <CAErSpo4mHTwqrW-yq_1BkjD0GyFtVYZRm9+eGfASJ_aJCOagjg@mail.gmail.com>
 <CAErSpo4xJk7bHQihtdN1UP+6Y17TOrBFhEsO_Zwyvz8iQMEXsw@mail.gmail.com>
 <51F8D5C9.4020309@huawei.com> <CAErSpo5GUTXyo4GeCGvh_GauKUA4decbDWUnD47qKPr6E65g9w@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 31 Jul 2013 14:42:36 -0600
Message-ID: <CAErSpo6yuxdngHepJ96w72SOSapud2URwc2GHPT_-CZh0e1CSA@mail.gmail.com>
Subject: Re: [PATCH] PCI: update device mps when doing pci hotplug
To: Yijing Wang <wangyijing@huawei.com>
Cc: Jon Mason <jdmason@kudzu.us>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Yijing Wang <wangyijing0307@gmail.com>,
        Hanjun Guo <guohanjun@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Joe Jin <joe.jin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 11:53 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, Jul 31, 2013 at 3:15 AM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Hi Bjorn,
>>    I didn't observe a performance difference between MPS=128 and MPS=512. I use ping $dest_ip -s 65500(large size packet)
>> to test the different situations.
>
> Interesting.  "ping" is probably not a good way to see performance
> differences, but hopefully you could see a difference in *some*
> scenario.  Otherwise, there's not much point in increasing MPS :)
>
>>> I assume there are no AER or other errors logged by the root port?
>> Yes, AER is not support in local machine.
>
> Per the 5520/5500 spec, it does support AER (sec 19.11.5).  Maybe
> there's some platform support required in addition.  You might still
> be able to see some info just with "lspci -vv"
>
>> Hmmm, PCIe Spec does not involve too much about MPS setting. So maybe different platform
>> has different strategy.
>
> I think there's enough in the spec to tell us what we need to do (this
> is sec 2.2.2):
>
>   - A Transmitter must not send a TLP larger than its Max_Payload_Size
>   - A Receiver must treat TLPs larger than its Max_Payload_Size as malformed
>
> The only way I can see to guarantee that is to set the MPS on both
> ends of the link the same.
>
>> Conservatively, as a improvement for mps setting after hotplug. I think update mps setting equal to its parent
>> make sense. This is no harm to other devices, we only modify the hotplug device itself mps register.
>>
>> So if you agree, I will update my patch ,only try to modify hotplug device mps, make them equal to its parent.
>
> Yes, I think that would be safe.  If the switch is set to a larger MPS
> than the hot-added device supports, I don't think we can safely use
> the device.

I opened a bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=60671
for this problem.  Please correct any mistakes in my summary and
reference it in your changelog.

Bjorn
