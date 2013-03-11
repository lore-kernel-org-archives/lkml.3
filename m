Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754178Ab3CKUM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 16:12:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12176 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab3CKUMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 16:12:55 -0400
Date: Mon, 11 Mar 2013 16:12:45 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311201245.GC14738@redhat.com>
References: <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
 <20130311192021.GF12107@redhat.com>
 <513E36CB.5040908@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <513E36CB.5040908@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:55:55PM -0700, H. Peter Anvin wrote:
> On 03/11/2013 12:20 PM, Vivek Goyal wrote:
> > 
> > I find it odd that if a user wants to load a 32bit kernel or use 32bit
> > entry point then he needs to first reboot the kernel and re-reserve
> > the memory.
> > 
> > At installation time, one does not necessarily know what kind of kernel
> > will be used for crashdump. So reserving as high as possible limits
> > the choices.
> > 
> > I would rather prefer that user opt in for higher addresses instead of
> > these being reserved by default.
> > 
> 
> Quite frankly the whole design seems to be held together with chewing
> gum.  At the core, the problem is a tight coupling between kexec-tools
> version, kexec-tools options, and kernel command line options that have
> to be combined in very ugly ways.  Part of the reason is that the kernel
> isn't actually given the information it needs to do the job required.
> 
> As far as "if a user wants to load"... why on Earth should that be the
> default?  How could that *not* be an exceptional case?

Because it breaks existing user cases. We had this limitation so far
that bzImage has to be loaded in first 896MB. And for 32bit bzImage
entry, I think that is still true?

So how can kernel assume that user is always loading a 64bit bzImage
and reserve memory accordingly.

Also in the past we did not have relocatable kernel and memory had to
be reserved at the address new kernel is built. Thankfully that is
no more the case.

Thanks
Vivek
