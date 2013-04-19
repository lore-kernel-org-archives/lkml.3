Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271Ab3DSJkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 05:40:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60964 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756008Ab3DSJkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 05:40:23 -0400
Date: Fri, 19 Apr 2013 10:39:53 +0100
From: Will Deacon <will.deacon@arm.com>
To: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC] arm64: Early printk support for virtio-mmio console
 devices.
Message-ID: <20130419093953.GD13283@mudshark.cambridge.arm.com>
References: <1366264344-28025-1-git-send-email-pranavkumar@linaro.org>
 <ede8ee08bb2616c2ed642200e3357367@localhost>
 <CAAHg+HhajHFC=1nh6YQNgpf=Na2FqcsYJ=t+ag9QiTg6TxUz9w@mail.gmail.com>
 <bb1193983de3ea9f4df1a570441df34c@localhost>
 <CAAHg+HhtCorArCmx=ha0=64+SJZiizzrDUKSPLV=N+OzO8zAxQ@mail.gmail.com>
 <20130419090558.GA13283@mudshark.cambridge.arm.com>
 <CAAHg+HipCX2ma6brxj9Kgc3ew39b5e30grLwyun9CViif-5wZQ@mail.gmail.com>
 <20130419092752.GB13283@mudshark.cambridge.arm.com>
 <CAFEAcA8j124G=vaHObJ_w5wOhUiS3KYKbjMnigbnr6mgwFxZUg@mail.gmail.com>
 <CAAHg+Hg=t97SJ0JPZYgrZaL+zimo-wbezwaj1BQvHqE-vf4VDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAHg+Hg=t97SJ0JPZYgrZaL+zimo-wbezwaj1BQvHqE-vf4VDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 19, 2013 at 10:34:56AM +0100, Pranavkumar Sawargaonkar wrote:
> On 19 April 2013 15:00, Peter Maydell <peter.maydell@linaro.org> wrote:
> > On 19 April 2013 10:27, Will Deacon <will.deacon@arm.com> wrote:
> >> On Fri, Apr 19, 2013 at 10:25:35AM +0100, Pranavkumar Sawargaonkar wrote:
> >>> I am not against using 8250 emulation (as far as it solves printk
> >>> issues for kernel booting logs), but my point is why not to add early
> >>> read-write support for virtio console, which also can be useful in
> >>> emulation less mach-virt environment also ?
> >>
> >> We can have both, but only one of those requires a change to the virtio
> >> specification.
> >
> > I don't think avoiding writing a spec is necessarily a good reason
> > for insisting on emulation of a lump of hardware 95% of whose
> > capabilities you aren't going to use...
> 
> True.
> Also 8250 will require emulation of registers, and i am not sure about
> if mach-virt will have any emulation of real hw ?

The point of mach-virt is that it is completely parameterised. So, if you're
not emulating an 8250, then don't tell the kernel that you have one!
Similarly, if you *do* emulate it, then either create a device-tree node for
it or pass the appropriate earlyprintk= string on the command line.

As far as kvmtool is concerned, we'd probably have a new command-line option
for arm64, allowing you to specify the early console device.

Will
