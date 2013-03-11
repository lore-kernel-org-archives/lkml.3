Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3CKVTk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 17:19:40 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:59593 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932101Ab3CKVTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 17:19:37 -0400
MIME-Version: 1.0
In-Reply-To: <F766E4F80769BD478052FB6533FA745D25F440A64D@SC-VEXCH4.marvell.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
	<CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com>
	<CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com>
	<CAErSpo6ascpN=bBUUzkk5W3-Wee_1ZztAyTwnKd-tq=L_9Q3mw@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440A477@SC-VEXCH4.marvell.com>
	<CAL-B5D1=zqB_9sWL9A_GgY6OgGdw18qxBHbgj_YG2bj0VGDh4Q@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D25F440A64D@SC-VEXCH4.marvell.com>
Date: Mon, 11 Mar 2013 15:19:36 -0600
Message-ID: <CAL-B5D3od8zhtYguH36r1XmHw_rvg0Tcdgv8ewYrgHFsJ2Sefw@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
From: Myron Stowe <myron.stowe@gmail.com>
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 3:15 AM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
> Hi, Myron
>
>> >>> >> > Fix system hang issue: if first accessed resource file of BAR0 ~
>> >>> >> > BAR4, system will hang after executing lspci command
>> >
>> > Any question? Thanks!
>>
>> Googling and looking at the PCI IDs data base I see that the Marvell
>> 9125 device has been around since sometime around 2010 and that there
>> even seem to be a number of follow-on iterations of the chip (i.e.
>> 9128, 9120, ...).  It seems incredibly unlikely that Marvell made a
>> device that has been shipping for 2+ years with five I/O BARs that do
>> not work and we are only now finding out such.
> Just only 9125 has the issue.
>
>> Am I missing something relevant here?  Can you verify that this device
>> has is indeed not new and has been successfully used in recent
>> platforms?
> The device can used in recent platforms.

Could you please be a little more explicit (and I'll try to be more
specific in my questions) as I was not able to get much, if any,
understanding from the responses.

I would like to understand if the 9125 device has had issues
corresponding to accessing the I/O Port space mapped by its BARS from
the very beginning - i.e. there have been no platforms in the last 2+
years that have been able to successfully drive this device using its
I/O BAR accessing methods?

What seems more likely is that only now, due to some new and yet
unknown reason, are issues corresponding to accessing the I/O Port
space mapped by its BARS occurring - perhaps something to do with a
new processor or chipset.

Are you seeing any similar issues when booting Windows on the same platform?

This information could be helpful in tracking down the root cause.

>
>> You just recently responded with  "... I just got the info from HP.
>> ..." so I'm assuming this is an issue that has just been encountered
>> on some type of HP system - is this correct?  If so, do you have
>> access to the system to provide the logs I asked for earlier?  Also,
>> is there anything special or completely new about this platform that
>> would explain away the arguments for why this is probably not a
>> Marvell device issue?
> I can reproduce the issue with following platform:
> CPU: Intel i7-3770 3.40GHZ
> OS: centos 6.4

6.4 is a fairly old kernel by now - 2.6.32.  Have you been able to try
an upstream kernel and if so, what were the results?

>
> Now, the situation is like this:
> I captured the PCIE trace with analyzer and found that 1st BE is 0x1111 when
> accessing IO port space. But 9125 spec has some limitation, and the BE must
> be
> 0x0100, to access the 2nd byte only. So, the chip will go to bad.

Great, this is new, interesting, data.  Is the 9125 spec publicly
accessible and/or could you elaborate on the "some limitation"
comment?

I'm fairly sure that PCI Express supports byte-granular accesses to
I/O port space (I'll try to read up on this some more as I don't
usually work at this low of a level) and it seems unlikely that this
area would be broken in a chipset, especially an Intel one.

A byte enable (BE) of 0x1111 suggests the CPU did a 32-bit I/O port
read.  Does the 9125 device only support one-byte I/O port accesses
and when presented with larger request types it doesn't respond
properly?  I have to admit I don't know what the correct response
would be - perhaps a master abort.  Do you know what the PCI host
controller would return to the CPU so the CPU wouldn't hang in such a
case?

> Can you tell me what can I do to fix the issue? Thanks!

Once we understand the root cause I'm sure we'll be able to come up
with a solution.  Let's keep honing in on the problem for now until we
get to that understanding.
>
>
>
