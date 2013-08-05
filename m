Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab3HEWwl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:52:41 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59306 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755365Ab3HEWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:52:40 -0400
Message-ID: <1375743157.18481.14.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [edk2] Corrupted EFI region
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Laszlo Ersek <lersek@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Fish <afish@apple.com>, edk2-devel@lists.sourceforge.net,
        linux-efi@vger.kernel.org, Gleb Natapov <gleb@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>
Date: Mon, 05 Aug 2013 15:52:37 -0700
In-Reply-To: <52001F6B.4000800@redhat.com>
References: <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com>
	 <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com>
	 <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com>
	 <20130805144010.GE31845@pd.tnic>
	 <2DBE3EA4-E321-4A7B-B9AF-EDE55BC2E358@apple.com>
	 <20130805181225.GH31845@pd.tnic> <52001B04.2050806@zytor.com>
	 <20130805214140.GB14067@pd.tnic> <52001F6B.4000800@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.8.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 23:55 +0200, Laszlo Ersek wrote:
> On 08/05/13 23:41, Borislav Petkov wrote:
> > On Mon, Aug 05, 2013 at 02:37:08PM -0700, H. Peter Anvin wrote:
> >> All of this would be a non-problem if there weren't buggy
> >> implementations which can't run *without* SetVirtualAddressMap().
> > 
> > Oh, you mean, if we were to call the runtime services through their
> > physical addresses?
> 
> I heard that there was a (U)EFI firmware implementation that didn't even
> implement SetVirtualAddressMap(). It was okay because the main OS for
> that platform didn't want to call it, it thunked to physical mode for
> each runtime service call.
> 
> (This is not hearsay; I'm omitting the specifics because I'm not sure if
> I'm allowed to give any. I've heard about this stuff from a direct
> colleague who used to work on these systems.)

That's actually the way all non-x86 unix systems operate.  If you look
in the firmware mechanisms for almost every non-x86 system in the Linux
kernel architecture directories they do this if they have to access
firmware from Linux (we do it a lot on parisc to get the IODC to give us
the device inventory for instance).

I strongly suspect the origin of this weirdness is that once upon a time
windows didn't run with a separated address space and so needed a way of
accessing firmware in the same address space, hence the pointer
relocation trick, but even windows hasn't needed this for a while.

James


