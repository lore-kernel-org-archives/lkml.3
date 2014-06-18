Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516AbaFRWkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:40:55 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:57069 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaFRWkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:40:53 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQXD7hvt0cUYMzvq0r6CbZn=iJZc7BHRaF2nACbG7qwuBQ@mail.gmail.com>
References: <1402346730-2508-1-git-send-email-andreas.noever@gmail.com>
 <20140617221620.GC30559@google.com> <CAE9FiQXD7hvt0cUYMzvq0r6CbZn=iJZc7BHRaF2nACbG7qwuBQ@mail.gmail.com>
From: Andreas Noever <andreas.noever@gmail.com>
Date: Thu, 19 Jun 2014 00:40:32 +0200
Message-ID: <CAMxnaaWWuNeNbnUe++N=2bBfs5JyKiq7tHH+_kiQZyQ9aakEHg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not touch siblings in pci_assign_unassigned_bridge_resources
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 1:39 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Tue, Jun 17, 2014 at 3:16 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> [+cc Yinghai]
>>
>> On Mon, Jun 09, 2014 at 10:45:30PM +0200, Andreas Noever wrote:
>>> The problem can be reproduced by having two sibling hotplug bridges A
>>> and B. The problem will occour if the parent of A and B does not have
>>> enough resources to satisfy window allocations for B during a hotplug
>>> event.
>
>> I don't understand how all this works either.  Yinghai?
>>
>> We definitely don't want to release resources that are already in use.  Can
>> you review and ack or nack this?
>
> Hi Andreas,
>
> Can you check if attached patch fix the problem on your test case?

It seems to fix the testcase (no unwanted resources are released). But
why do you reassign bus and not just skip the top level bridge? If one
of the allocations below bridge failed then a resource of that device
will be in fail_res and bridge->subordinate will get released anyways?
Also by not removing fail_res from the list you trigger the code in
the next loop for the top level bridge (in particular the res->flags =
0 line looks dangerous).

Could you explain why this function attempts to assign resources two
times? In which scenario will a second attempt be successful?

Thanks,
Andreas

> In some case, if we can not assign pref mmio properly for the bridge,
> we may need to even clear non-pref mmio for the bridge.
>
> Thanks
>
> Yinghai
