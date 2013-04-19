Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab3DSKGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 06:06:11 -0400
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34039 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754804Ab3DSKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 06:06:10 -0400
MIME-Version: 1.0
In-Reply-To: <20130419093953.GD13283@mudshark.cambridge.arm.com>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
 <ede8ee08bb2616c2ed642200e3357367@localhost> <CAAHg+HhajHFC=1nh6YQNgpf=Na2FqcsYJ=t+ag9QiTg6TxUz9w@mail.gmail.com>
 <bb1193983de3ea9f4df1a570441df34c@localhost> <CAAHg+HhtCorArCmx=ha0=64+SJZiizzrDUKSPLV=N+OzO8zAxQ@mail.gmail.com>
 <20130419090558.GA13283@mudshark.cambridge.arm.com> <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
 <20130419092752.GB13283@mudshark.cambridge.arm.com> <CAFEAcA8j124G=vaHObJ_w5wOhUiS3KYKbjMnigbnr6mgwFxZUg@mail.gmail.com>
 <CAAHg+Hg=t97SJ0JPZYgrZaL+zimo-wbezwaj1BQvHqE-vf4VDA@mail.gmail.com> <20130419093953.GD13283@mudshark.cambridge.arm.com>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 19 Apr 2013 11:05:47 +0100
Message-ID: <CAFEAcA_WfYpyvq54rZqS8JZkmDF5JXB+CNHFH5CnrhKun52uzA@mail.gmail.com>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console devices.
To: Will Deacon <will.deacon@arm.com>
Cc: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 April 2013 10:39, Will Deacon <will.deacon@arm.com> wrote:
> The point of mach-virt is that it is completely parameterised. So, if you're
> not emulating an 8250, then don't tell the kernel that you have one!
> Similarly, if you *do* emulate it, then either create a device-tree node for
> it or pass the appropriate earlyprintk= string on the command line.
>
> As far as kvmtool is concerned, we'd probably have a new command-line option
> for arm64, allowing you to specify the early console device.

Please make the kernel pick the device out of the device tree
blob. The whole point of device tree is that it's how to tell
the kernel where things live -- making kvmtool/QEMU and/or the
user also have to mess with the kernel command line is awkward
and annoying.

-- PMM
