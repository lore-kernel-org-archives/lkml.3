Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757231Ab3DSQPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 12:15:00 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57329 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909Ab3DSQO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 12:14:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130419161201.GA5383@localhost.cambridge.arm.com>
References: <CAAHg+HhajHFC=1nh6YQNgpf=Na2FqcsYJ=t+ag9QiTg6TxUz9w@mail.gmail.com>
 <bb1193983de3ea9f4df1a570441df34c@localhost> <CAAHg+HhtCorArCmx=ha0=64+SJZiizzrDUKSPLV=N+OzO8zAxQ@mail.gmail.com>
 <20130419090558.GA13283@mudshark.cambridge.arm.com> <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
 <20130419092752.GB13283@mudshark.cambridge.arm.com> <CAFEAcA8j124G=vaHObJ_w5wOhUiS3KYKbjMnigbnr6mgwFxZUg@mail.gmail.com>
 <CAAHg+Hg=t97SJ0JPZYgrZaL+zimo-wbezwaj1BQvHqE-vf4VDA@mail.gmail.com>
 <20130419093953.GD13283@mudshark.cambridge.arm.com> <CAFEAcA_WfYpyvq54rZqS8JZkmDF5JXB+CNHFH5CnrhKun52uzA@mail.gmail.com>
 <20130419161201.GA5383@localhost.cambridge.arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 19 Apr 2013 17:14:36 +0100
Message-ID: <CAFEAcA-F18kR4JihdxaLTm3qb4n51tsygG1RW4djwJ0u9+FQqw@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 April 2013 17:12, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Fri, Apr 19, 2013 at 11:05:47AM +0100, Peter Maydell wrote:
>> Please make the kernel pick the device out of the device tree
>> blob. The whole point of device tree is that it's how to tell
>> the kernel where things live -- making kvmtool/QEMU and/or the
>> user also have to mess with the kernel command line is awkward
>> and annoying.
>
> For a normal console device, it indeed needs to get it from the DT. For
> early console, you want it earlier than DT parsing so we pass it on the
> kernel command line via the earlyprintk= parameter.

You should fix your DT handling code so you can get at the info
when you need it rather than pushing the problem into bootloaders
and QEMU, please. DT is your data structure so feel free to
(re)design it so relevant information can be accessed early
if that's useful.

thanks
-- PMM
