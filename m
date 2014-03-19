Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533AbaCSVXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 17:23:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26709 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaCSVXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 17:23:46 -0400
Message-ID: <532A0AB9.5050907@oracle.com>
Date: Wed, 19 Mar 2014 17:23:05 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ming Lei <tom.leiming@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 8/9] PCI: Ignore BAR contents when firmware left decoding
 disabled
References: <20140226192614.10125.68711.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140226193757.10125.81865.stgit@bhelgaas-glaptop.roam.corp.google.com> <20140319185423.GA5514@google.com> <CAErSpo42K6W8b+7A7dyxUp-rNQttMQY7jcbpgyGv9sctyAqJCA@mail.gmail.com>
In-Reply-To: <CAErSpo42K6W8b+7A7dyxUp-rNQttMQY7jcbpgyGv9sctyAqJCA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2014 05:16 PM, Bjorn Helgaas wrote:
> On Wed, Mar 19, 2014 at 12:54 PM, Bjorn Helgaas<bhelgaas@google.com>  wrote:
>> >[+cc Ming, Rusty, Pekka, Sasha]
>> >...
>> >I plan to replace this patch with the following, which only sets
>> >IORESOURCE_UNSET when we already have been clearing the bus region start
>> >address.  (This probably should have been a separate patch to begin with,
>> >mea culpa.)
>> >
>> >This is intended for the v3.15 merge window, so I made the minimal change
>> >to reduce risk.
> I put this patch in my pci/resource branch and re-merged it into my
> "next" branch.  This rebased both pci/resource and next, which is
> unfortunate, but I think it's the cleanest and least risky way at this
> point.

Thanks for pointing out the issue Ming. I must admit that I haven't referred
to the PCI spec when sending in my "fix" since the upstream patch sort of
made sense. OTOH, you can't really call the kvm tool PCI implementation spec
compliant :)

Pekka, we can either revert my patch completely since the issue won't ever be
visible (since the pci tree got rebase) or just keep it in. Let me know what you
prefer.


Thanks,
Sasha
