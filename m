Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444Ab3CKTU1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 15:20:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39883 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750948Ab3CKTU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 15:20:26 -0400
Date: Mon, 11 Mar 2013 15:20:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
Message-ID: <20130311192021.GF12107@redhat.com>
References: <513D52BA.3070206@redhat.com>
 <1362977817-23297-1-git-send-email-yinghai@kernel.org>
 <20130311144853.GB8482@redhat.com>
 <20130311150256.GC8482@redhat.com>
 <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com>
 <20130311182655.GB12107@redhat.com>
 <513E2695.3080707@zytor.com>
 <CAE9FiQXLodhSFy4T9pKLMS+axF0jHGL9B0+TL=dYOFrLVudN9g@mail.gmail.com>
 <513E28B8.3000502@zytor.com>
 <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW-gpEMmc6kseb7E+TEg1F9CqEYZBRDiJ3bDY=t6zGRmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 12:06:06PM -0700, Yinghai Lu wrote:

[..]
> > I actually disagree with trying low memory at all.  Push kdump as high
> > into the memory range as we can go, if there is a performance penalty it
> > is much better to take it in the kdump kernel.
> 
> Agreed, It's better let 64 bit all use one code path.
> And we can find more bugs while load them all high.
> otherwise it would be hard to fix them if the bugs only happens on systems
> that have bunch of dimms.

I find it odd that if a user wants to load a 32bit kernel or use 32bit
entry point then he needs to first reboot the kernel and re-reserve
the memory.

At installation time, one does not necessarily know what kind of kernel
will be used for crashdump. So reserving as high as possible limits
the choices.

I would rather prefer that user opt in for higher addresses instead of
these being reserved by default.

Thanks
Vivek
