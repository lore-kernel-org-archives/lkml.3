Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292Ab3HEQjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:39:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28803 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3HEQje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:39:34 -0400
Message-ID: <51FFD5B0.9080000@redhat.com>
Date: Mon, 05 Aug 2013 18:41:20 +0200
From: Laszlo Ersek <lersek@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130621 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: edk2-devel@lists.sourceforge.net, David Woodhouse <dwmw2@infradead.org>,
        linux-efi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@redhat.com>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [edk2] Corrupted EFI region
References: <20130731205431.GG4724@pd.tnic> <1375307727.22084.103.camel@shinybook.infradead.org> <20130801164927.GA7445@pd.tnic> <51FF8C14.2070405@redhat.com> <20130805130258.GB31845@pd.tnic> <51FFAB13.4090603@redhat.com> <20130805140306.GD31845@pd.tnic> <51FFB660.4060400@redhat.com> <20130805144010.GE31845@pd.tnic> <51FFC19A.1020204@redhat.com> <20130805161247.GF31845@pd.tnic>
In-Reply-To: <20130805161247.GF31845@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/13 18:12, Borislav Petkov wrote:
> On Mon, Aug 05, 2013 at 05:15:38PM +0200, Laszlo Ersek wrote:
>> The current implementation (how pointers are converted) probably doesn't
>> accommodate a second call.
>>
>> Of course you want to know why SetVirtualAddressMap() was designed like
>> that... I didn't participate in the design so I don't know :)
>>
>> But, as I said, a kernel directly executing another kernel is an
>> unexpected idea. IMHO the second kernel in question doesn't fit the UEFI
>> phases at all. The OS booted like that (ie. the OS whose kernel is the
>> 2nd (=kexec) kernel) never goes through SEC, PEI, DXE, BDS.
> 
> Yes, the thing is, imposing unnecessary restrictions is very
> counterproductive. And kexec is just an example here - if
> SetVirtualAddressMap was callable an arbitrary number of times, this
> whole work I'm doing is unnecessary. So I'm jumping through hoops just
> to accomodate a braindead design.

I doubt it was a deliberate restriction. More like, there was no
incentive (... that the designers were aware of) *not* to design
something easy (or easier) to implement. Your use case has come later.

> This is what I cannot fathom in the face of people praising UEFI as the
> solution to all problems.

I agree that such people exist. I'm not one of them.

>> BTW there's another point I'd like to ask about -- you're saying you
>> see the region corruption during the same boot, from the first (early)
>> memmap dump to the second one (when just about to enter virtual mode).
>> But, is this one boot the very first boot, or the kexec one?
> 
> No, kexec is not even involved yet. If you look at the timestamps,
> there's 0.005 seconds between the two dumps during the *same* kernel
> booting on the machine, baremetal, straight from grub.

I didn't realize the timestamps survive kexec. (As far as I remember the
kernels I played with kexec on didn't have the automatic timestamps yet
in dmesg, but I might have messed up just as well...)

Laszlo
