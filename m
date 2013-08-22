Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab3HVRpT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 13:45:19 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:45582 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab3HVRpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 13:45:16 -0400
MIME-Version: 1.0
In-Reply-To: <1367960849.23964.YahooMailNeo@web140002.mail.bf1.yahoo.com>
References: <1367700969.8582.YahooMailNeo@web140004.mail.bf1.yahoo.com>
 <CAErSpo4C3-WH6_GOnmz1TgKsD3SyNGQYeU8Cj0=_+c+9K2yS+A@mail.gmail.com> <1367960849.23964.YahooMailNeo@web140002.mail.bf1.yahoo.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 22 Aug 2013 11:44:54 -0600
Message-ID: <CAErSpo6O+7jv2KPXm3U1syG+2T2MbWqNfHBt=eTYe-72ACTKAg@mail.gmail.com>
Subject: Re: 3.9.0 dmesg reports that my NIC is hanging
To: John <da_audiophile@yahoo.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 7, 2013 at 3:07 PM, John <da_audiophile@yahoo.com> wrote:
>
>
>
>
> ----- Original Message -----
>> From: Bjorn Helgaas <bhelgaas@google.com>
>> To: John <da_audiophile@yahoo.com>
>> Cc: lkml <linux-kernel@vger.kernel.org>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>; "e1000-devel@lists.sourceforge.net" <e1000-devel@lists.sourceforge.net>
>> Sent: Monday, May 6, 2013 1:29 PM
>> Subject: Re: 3.9.0 dmesg reports that my NIC is hanging
>>
>> [+cc Jeff, e1000-devel (from MAINTAINERS)]
>>
>> On Sat, May 4, 2013 at 1:56 PM, John <da_audiophile@yahoo.com> wrote:
>>>  After upgrading to the official Arch Linux 3.9-2 kernel package, dmesg
>> reports that my NIC is hanging:
>>>
>>>  [    5.955720] e1000e 0000:00:19.0 eno1: changing MTU from 1500 to 4000
>>>  [    8.464507] e1000e 0000:00:19.0 eno1: Detected Hardware Unit Hang:
>>>    TDH                  <0>
>>>    TDT                  <2>
>>>    next_to_use          <2>
>>>    next_to_clean        <0>
>>>  buffer_info[next_to_clean]:
>>>    time_stamp           <fffea787>
>>>    next_to_watch        <0>
>>>    jiffies              <fffeaa30>
>>>    next_to_watch.status <0>
>>>  MAC Status             <40080080>
>>>  PHY Status             <7949>
>>>  PHY 1000BASE-T Status  <0>
>>>  PHY Extended Status    <3000>
>>>  PCI Status             <10>
>>>
>>>  Not too sure what else to post.  I am not subscribed to lkml so please cc
>> my email in your reply.
>>>
>>>
>>>  Link to complete dmesg: http://pastebin.com/zRBajGrY
>>>  Seems similar to: bugzilla.redhat.com/show_bug.cgi?id=785806
>>
>> It sounds like this is a regression, so it might be useful to know
>> what the newest working kernel was, and maybe a dmesg log from it as
>> well, though I don't see any obvious clues in the 3.9.0-2-ARCH dmesg
>> you collected.
>>
>> Bjorn
>
>
> Thank you for the reply, Bjorn.  3.8.11-1-ARCH works just fine for me.  Here is the dmesg from 3.8.11-1-ARCH per your request: http://pastebin.com/cUHwrQfq

Sorry this thread died.  Did this ever get resolved?

If not, can you collect "lspci -vv" output for the whole system on
both the working kernel and the failing one?

There are reports of similar symptoms at [1] and [2].  I can't tell
yet if you're seeing the same problem, but for [1], booting with
"pci=pcie_bus_peer2peer" was a workaround.

Bjorn

[1] http://lkml.kernel.org/r/509B5038.8090304@oracle.com [2012-11-08]
[2] http://lkml.kernel.org/r/4FFA9B96.6040901@oracle.com [2012-07-09]
