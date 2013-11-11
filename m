Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab3KKLkH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 06:40:07 -0500
Received: from hermes.synopsys.com ([198.182.44.81]:40066 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3KKLj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 06:39:59 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Linus Walleij <linus.walleij@linaro.org>, arnd Bergmann <arnd@arndb.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.ruppert@abilis.com" <christian.ruppert@abilis.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [GIT PULL] pin control bulk changes for v3.13
Thread-Topic: [GIT PULL] pin control bulk changes for v3.13
Thread-Index: AQHO3sEiKrO36hVs10O31J+CRXvZFg==
Date: Mon, 11 Nov 2013 11:39:54 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA23075155DCE@IN01WEMBXA.internal.synopsys.com>
References: <CACRpkdYpuZec_JRAPYZHmB5qTYebKR6iBy5=RvBUUEXsuOu97Q@mail.gmail.com>
	<52808D34.70309@synopsys.com>
	<CACRpkdaRGKBWr+rtOD3tWBUA452yApF838ufZ6nPOhzMZGDzfg@mail.gmail.com>
	<C2D7FE5348E1B147BCA15975FBA23075155D9F@IN01WEMBXA.internal.synopsys.com>
 <CACRpkdYPgNK=bODvTo8+KHG7Yz448rw10Mqov8AjRB5RGMcqhg@mail.gmail.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.15.84.232]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:53 PM, Linus Walleij wrote:
> On Mon, Nov 11, 2013 at 11:00 AM, Vineet Gupta
> <Vineet.Gupta1@synopsys.com> wrote:
>> On 11/11/2013 03:03 PM, Linus Walleij wrote:
>>> Actually I think device tree changes - if you mean changes to this platform's
>>> DTS/DTSI files, should go through the ARC arch tree.
>> But current workflow is prone to broken bisectability - arch maintainers need to
>> make sure that the core/driver changes hit mainline before the actual dts/dtsi
>> files in arch/*
> No. This is *not* a bisectability problem, as it has been established
> that device trees and kernel code shall *not* be built and deployed
> together.

Well that is a fine design *goal*. But in reality (at least his patch) is making a
driver change and then enabling arch via DT to access it. I can't fathom what is
the issue with having both the changes routed via the same tree - other than
possible merge hassles - which can can PITA for arches such as ARM. So you can say
that as a general *practice* subsys guys don't prefer what I'm asking for and I'm
OK if you reason it that way. But saying that it is not a bisectability problem
and is design goal etc is bogus IMO.

> Consider:
>
> - Just subsystem changes are merged: OK you can still take your
>   DTS from somewhere and boot this kernel with it.
>
> - Just the arch/*/*.dts[i] changes are merged: OK these new DT
>   nodes remain unused, presumably the system survives anyway?
>
> It only becomes a problem if you also start to apply patches deleting
> functionality that has been moved over to the device tree in the same
> merge window - don't do that. Take a sweep with the broomstick
> next time instead.

Ya Ya I see, but the patch under consideration don't fall in either of those
buckets. We have 1 change in each of arch and subsys.

-Vineet
