Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab3C2RFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:05:18 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53722 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab3C2RFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:05:16 -0400
Message-ID: <5155C9C6.4070702@wwwdotorg.org>
Date: Fri, 29 Mar 2013 11:05:10 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: Pavel Machek <pavel@ucw.cz>, Grant Likely <grant.likely@secretlab.ca>,
        kernel list <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.9-rc1 regression in arm dtb build
References: <20130306193332.GA6022@amd.pavel.ucw.cz> <5137C404.9060902@wwwdotorg.org> <20130307144506.GB7344@amd.pavel.ucw.cz> <5138FDAE.8060202@wwwdotorg.org> <20130311050546.GA21863@quad.lixom.net> <CACxGe6vkC7fjzf1-+K8O81+w=jQ63PvuTEhSPyitEBA9XiKYnw@mail.gmail.com> <20130328092916.GA11187@amd.pavel.ucw.cz> <51545870.4010209@wwwdotorg.org> <20130328193323.GA25166@amd.pavel.ucw.cz> <20130328195456.GA22527@quad.lixom.net>
In-Reply-To: <20130328195456.GA22527@quad.lixom.net>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2013 01:54 PM, Olof Johansson wrote:
> On Thu, Mar 28, 2013 at 08:33:23PM +0100, Pavel Machek wrote:
>> On Thu 2013-03-28 08:49:20, Stephen Warren wrote:
>>> On 03/28/2013 03:29 AM, Pavel Machek wrote:
>>> ...
>>>> There's change that makes it pretty much impossible to build dtbs
>>>> reliably between different kernel versions, because it leaves old dtbs
>>>> around, and they survive even make clean.
>>>
>>> One question here: Presumably the dtbs don't survive "make clean" if you
>>> run that right after building the dtbs, but only if you check out a new
>>> kernel version before running clean? Or is that not the case?
>>
>> That was the case I seen, yes.
>>
>> Have old kernel running, dtbs building. Apply a patch. It starts
>> behaving weird. You do make clean... but you still get old dtbs.
>>
>> (It would be nice if make socfpga_cyclone5.dtb would magically remove
>> all the dtbs from old location; make dtbs does that if I understand
>> stuff correctly).
> 
> 
> This takes care of the "make dtbs" case (or just "make" case), but not
> when you build a specific target.

I guess to really solve this, we need the following changes:

In the all kernels:

For both arch/*/boot and arch/*/boot/dts: clean removes *.dtb

In kernels that build *.dtb in the new location:

make dtbs and make foo.dtb both rm ../*.dtb

In kernels that build *.dtb in the old location:

make dtbs and make foo.dtb both rm dts/*.dtb

Is that too much to retrofit into all the stable kernels?
