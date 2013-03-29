Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980Ab3C2Tla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:41:30 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:52468 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756675Ab3C2Tl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:41:28 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:47c:d90f:eea8:ac64]
In-Reply-To: <5155C9C6.4070702@wwwdotorg.org>
References: <20130306193332.GA6022@amd.pavel.ucw.cz>
	<5137C404.9060902@wwwdotorg.org>
	<20130307144506.GB7344@amd.pavel.ucw.cz>
	<5138FDAE.8060202@wwwdotorg.org>
	<20130311050546.GA21863@quad.lixom.net>
	<CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com>
	<20130328092916.GA11187@amd.pavel.ucw.cz>
	<51545870.4010209@wwwdotorg.org>
	<20130328193323.GA25166@amd.pavel.ucw.cz>
	<20130328195456.GA22527@quad.lixom.net>
	<5155C9C6.4070702@wwwdotorg.org>
Date: Fri, 29 Mar 2013 12:41:27 -0700
Message-ID: <CAOesGMj5yN_-Xvks=tYqYw1M1mre-uKQFCTXOe_gPE=abqF_GA@mail.gmail.com>
Subject: Re: 3.9-rc1 regression in arm dtb build
From: Olof Johansson <olof@lixom.net>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Pavel Machek <pavel@ucw.cz>, Grant Likely <grant.likely@secretlab.ca>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 10:05 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 03/28/2013 01:54 PM, Olof Johansson wrote:
>> On Thu, Mar 28, 2013 at 08:33:23PM +0100, Pavel Machek wrote:
>>> On Thu 2013-03-28 08:49:20, Stephen Warren wrote:
>>>> On 03/28/2013 03:29 AM, Pavel Machek wrote:
>>>> ...
>>>>> There's change that makes it pretty much impossible to build dtbs
>>>>> reliably between different kernel versions, because it leaves old dtbs
>>>>> around, and they survive even make clean.
>>>>
>>>> One question here: Presumably the dtbs don't survive "make clean" if you
>>>> run that right after building the dtbs, but only if you check out a new
>>>> kernel version before running clean? Or is that not the case?
>>>
>>> That was the case I seen, yes.
>>>
>>> Have old kernel running, dtbs building. Apply a patch. It starts
>>> behaving weird. You do make clean... but you still get old dtbs.
>>>
>>> (It would be nice if make socfpga_cyclone5.dtb would magically remove
>>> all the dtbs from old location; make dtbs does that if I understand
>>> stuff correctly).
>>
>>
>> This takes care of the "make dtbs" case (or just "make" case), but not
>> when you build a specific target.
>
> I guess to really solve this, we need the following changes:
>
> In the all kernels:
>
> For both arch/*/boot and arch/*/boot/dts: clean removes *.dtb
>
> In kernels that build *.dtb in the new location:
>
> make dtbs and make foo.dtb both rm ../*.dtb

I don't think this is useful. If you're building a specific dtb
target, there should be no expectation that other dtb files should
automatically be removed.

The original complaint was that make clean didn't remove the old dtb
files. That's been resolved with the provided patch.

I don't think it's worth the hassle of trying to remove ../foo.dtb.

> In kernels that build *.dtb in the old location:
>
> make dtbs and make foo.dtb both rm dts/*.dtb
>
> Is that too much to retrofit into all the stable kernels?

I also don't think this is worth the effort. If you're going to check
out old and new kernels in the same tree, you should probably get into
the habit of using git clean.

Perhaps we need a "dtb_install" target instead, so people stop copying
from the source directories.


-Olof
