Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab3DSRkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 13:40:40 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:45847 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab3DSRkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 13:40:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130419171455.GA43450@MacBook-Pro.local>
References: <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
 <20130419092752.GB13283@mudshark.cambridge.arm.com> <CAFEAcA8j124G=vaHObJ_w5wOhUiS3KYKbjMnigbnr6mgwFxZUg@mail.gmail.com>
 <CAAHg+Hg=t97SJ0JPZYgrZaL+zimo-wbezwaj1BQvHqE-vf4VDA@mail.gmail.com>
 <20130419093953.GD13283@mudshark.cambridge.arm.com> <CAFEAcA_WfYpyvq54rZqS8JZkmDF5JXB+CNHFH5CnrhKun52uzA@mail.gmail.com>
 <20130419161201.GA5383@localhost.cambridge.arm.com> <CAFEAcA-F18kR4JihdxaLTm3qb4n51tsygG1RW4djwJ0u9+FQqw@mail.gmail.com>
 <20130419162226.GB5383@localhost.cambridge.arm.com> <CAFEAcA_vdXbtK=U2gauC=DsrB=_cSfcUTaNCiB0Ts4YOq_pXEg@mail.gmail.com>
 <20130419171455.GA43450@MacBook-Pro.local>
From: Peter Maydell <peter.maydell@linaro.org>
Date: Fri, 19 Apr 2013 18:40:18 +0100
Message-ID: <CAFEAcA_Xhe2ggxUf=Ezrjozf2Y4h4BtCNPyVG=QD8b6kcqrUnQ@mail.gmail.com>
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

On 19 April 2013 18:14, Catalin Marinas <catalin.marinas@arm.com> wrote:
> On Fri, Apr 19, 2013 at 05:33:18PM +0100, Peter Maydell wrote:
>> The command line lives in the DTB anyway so if you can't look
>> in the DTB you can't get at earlyprintk config either way.
>
> Linux indeed looks in the DT for the command line and that's what's
> triggering the earlyprintk console but at that stage the DT is flat.
> Unflattening the DT happens later (it requires slab allocator). I
> initially thought about extracting the early console device from the DT
> but when it is flat you can't parse the full hierarchy to get its
> address.

So you could add a DT property that specifies the information in a
format that you can get at at the right time. That's annoying
duplication, but at least it's not in the command line (which is
a raw ascii string that QEMU &co shouldn't have to be parsing or
editing). "/console/type" and "/console/address" or something?

-- PMM
