Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaBEKMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 05:12:34 -0500
Received: from ducie-dc1.codethink.co.uk ([37.128.190.40]:37641 "EHLO
	ducie-dc1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835AbaBEKMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 05:12:30 -0500
Message-ID: <52F20E8B.4070108@codethink.co.uk>
Date: Wed, 05 Feb 2014 10:12:27 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
Organization: Codethink Limited.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-pci@vger.kernel.org, SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Valentine Barshak <valentine.barshak@cogentembedded.com>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 00/04] PCI: rcar: Driver model and physical address space
 update
References: <20140205065243.29445.76593.sendpatchset@w520> <52F1F74C.2090106@codethink.co.uk> <CANqRtoRMAjBEXjBzivPxqMu8KhFsOkp0wb6jBbuZQx=B-qYuUA@mail.gmail.com> <52F20388.9080109@codethink.co.uk> <CANqRtoRUWC5ioDXJdEM6utQo2uHB3xar3RHzapR--xhjRmRQag@mail.gmail.com>
In-Reply-To: <CANqRtoRUWC5ioDXJdEM6utQo2uHB3xar3RHzapR--xhjRmRQag@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/14 09:40, Magnus Damm wrote:
> On Wed, Feb 5, 2014 at 6:25 PM, Ben Dooks <ben.dooks@codethink.co.uk> wrote:
>> On 05/02/14 09:00, Magnus Damm wrote:
>>>
>>> Hi Ben,
>>
>>
>> [snip]
>>
>>> I think we should try to pick out the stuff that is ready to be merged
>>> first. I think these patches may require a bit of time before people
>>> start looking at them. I don't mind resending in the future.
>>>
>>> To be honest, I have not been paying too much attention to other
>>> patches including yours - been focused trying to get the memory
>>> management part right.. So I'd like to focus on correctness over DT
>>> for now if possible. Of course we it all.
>>>
>>> Would it be possible for you to provide a list of pci-rcar-gen2.c
>>> patches that you posted? Or perhaps you can resend your series and
>>> include acks that you received?
>>
>>
>> I don't think I have any acks, only review comments. I think the code
>> itself is pretty much ready to be merged and has been tested here with
>> the Lager board.
>
> Ok, thanks. I'd like to go through them myself if possible. I was
> looking for a cover letter or something that listed the patches but I
> can't seem to find it. Can you please provide a list?

I will re-send the patches once I've applied the relevant fixups from
the last round, hopefully within the next few hours.

>> The big issue for us is that we /must/ boot with fdt, which means the
>> less fdt support that is in the kernel then the more patches we end up
>> carrying out of tree. This is why we have been pushing patches out to
>> try and get the support in.
>
> Can you please define "boot with fdt"? As you probably know, both
> board-lager.c and board-lager-reference.c boot with DT. I suppose you
> mean that you want DT to describe the entire system, with no C code
> for the board? Please note that some devices like timers still don't
> use DT, so if you can live without those then... =)

We currently have enough to use the system. And yes, we boot with
board-lager-reference.c which current seems to be turning up bugs
in the up-stream (see the recent new bug with cpg clock code reported
by my colleague).

Due to issues out of our control we can test with board-lager.c but
we must use the board-lager-reference.c for actual product test. The
only way we found around this is ugly hacking of the core driver code
to link platform and fdt devices...

-- 
Ben Dooks				http://www.codethink.co.uk/
Senior Engineer				Codethink - Providing Genius
