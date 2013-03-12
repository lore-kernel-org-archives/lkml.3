Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147Ab3CLQVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 12:21:47 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:60940 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933095Ab3CLQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 12:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <F766E4F80769BD478052FB6533FA745D25F440A9C6@SC-VEXCH4.marvell.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
 <CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F436856A@SC-VEXCH4.marvell.com>
 <CAErSpo6RDC+QyyN4kwt7-kU5d8b1iu+zCQZTGZPxCJU2UicTCA@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F436861C@SC-VEXCH4.marvell.com>
 <CAErSpo6ascpN=bBUUzkk5W3-Wee_1ZztAyTwnKd-tq=L_9Q3mw@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F440A477@SC-VEXCH4.marvell.com>
 <CAL-B5D1=zqB_9sWL9A_GgY6OgGdw18qxBHbgj_YG2bj0VGDh4Q@mail.gmail.com>
 <F766E4F80769BD478052FB6533FA745D25F440A64D@SC-VEXCH4.marvell.com>
 <CAL-B5D3od8zhtYguH36r1XmHw_rvg0Tcdgv8ewYrgHFsJ2Sefw@mail.gmail.com> <F766E4F80769BD478052FB6533FA745D25F440A9C6@SC-VEXCH4.marvell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 12 Mar 2013 10:21:24 -0600
Message-ID: <CAErSpo7ufeQK1e=HSTYCNie7yfPouYE4-ot9dUX5r-upBtVt=A@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
To: Xiangliang Yu <yuxiangl@marvell.com>
Cc: Myron Stowe <myron.stowe@gmail.com>, yxlraid <yxlraid@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 3:22 AM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
> Hi, Myron
>> > Now, the situation is like this:
>> > I captured the PCIE trace with analyzer and found that 1st BE is 0x1111
>> > when
>> > accessing IO port space. But 9125 spec has some limitation, and the BE
>> > must
>> > be
>> > 0x0100, to access the 2nd byte only. So, the chip will go to bad.
>>
>> Great, this is new, interesting, data.  Is the 9125 spec publicly
>> accessible and/or could you elaborate on the "some limitation"
>> comment?
> 9125 spec is publicly accessible.

Please provide a URL for the spec.

>> A byte enable (BE) of 0x1111 suggests the CPU did a 32-bit I/O port
>> read.  Does the 9125 device only support one-byte I/O port accesses
>> and when presented with larger request types it doesn't respond
>> properly?
> Yes, the hardware engineer had confirmed the situation.

Please provide a URL for the erratum describing this 9125 issue.

Bjorn
