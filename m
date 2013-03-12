Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3CLIf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:35:57 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:46499 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab3CLIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:35:54 -0400
Date: Tue, 12 Mar 2013 09:35:41 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130312083541.GC30665@gmail.com>
References: <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
 <20130311201245.GC14738@redhat.com>
 <513E3C44.9030402@zytor.com>
 <87hakhk6xu.fsf@xmission.com>
 <20130311204530.GE14738@redhat.com>
 <513E438D.5010303@zytor.com>
 <20130311210333.GF14738@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130311210333.GF14738@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vivek Goyal <vgoyal@redhat.com> wrote:

> On Mon, Mar 11, 2013 at 01:50:21PM -0700, H. Peter Anvin wrote:
> > On 03/11/2013 01:45 PM, Vivek Goyal wrote:
> > > 
> > > - Now we use dracut generated initramfs and it has been growing in 
> > >   size. Now systemd has been pulled in too.
> > 
> > And the solution to that isn't obvious?
> 
> Sorry, I did not understand what do you mean by above.
> 
> If you are suggesting that move away from dracut, it does not work in 
> practice. Initially we wrote our custom code to generate custom 
> initramfs, and we were always lagging in terms of what dump targets can 
> be supported and kept on constantly fixing the issues which had been 
> taken care of in dracut one way or other. So it was like maintaining a 
> duplicate initramfs generation tool.

The fundamental design problem is this artificial split of the kernel from 
kexec-tools, just to support an arguably exotic feature, which in turn 
then tries to support a complex compatibility matrix - making each variant 
even more super exotic. There's just not enough usage and not enough 
manpower to keep all that tidy ...

If there was tools/kexec/ then many of these constraints and quirks with 
old versions would go away: old kernels would come with old kexec tools, 
new kernels would come with new kexec tools.

Just look at how tools/perf/ is packaged up with new kernels: you 
generally get a new perf with a new kernel version. Alone this eliminates 
a fair bit of support complexity and makes it easier to keep users 
uptodate.

[ kexec tooling could go even farther: if included in the initramfs then
  it could do away with ABI constraints and compatibility expectations
  altogether.

  This is one of the cases where it _does_ make sense: kexec tools and in
  general kernel image analysis is obviously coupled to the kernel's
  current data structures. ]

If this was fixed then kexec could step a whole lot further, not just in 
terms of robustness, but also in terms of feature set - and, ultimately, 
increased usage by users and kernel developers.

Thanks,

	Ingo
