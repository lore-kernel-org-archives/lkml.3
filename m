Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964880AbbA2D7W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:59:22 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46056 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762021AbbA2D7U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 22:59:20 -0500
Message-ID: <54C9AFF2.6000108@ti.com>
Date: Wed, 28 Jan 2015 21:58:42 -0600
From: Suman Anna <s-anna@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robherring2@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v7 1/4] Documentation: dt: add common bindings for hwspinlock
References: <1421269101-51105-2-git-send-email-s-anna@ti.com> <20150115135201.GG16217@leverpostej> <20150115135556.GH16217@leverpostej> <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com> <CAK=WgbYQ=BbinqJ5fsw2Y+FKdy=nasLsw9mX8pw6S_o3owy9-g@mail.gmail.com> <20150116101746.GA21809@leverpostej> <CAK=WgbYBqPoUm9byx0du_g5ZmHdYaUVLpSPZYHoCVzNoatNKpw@mail.gmail.com> <20150120180548.GK7718@atomide.com> <CAK=WgbZGGtwmQwzWumjpYOsYHTt8vPQpTraABwJBsv5VXOmJ_Q@mail.gmail.com> <54BFE855.3090200@ti.com> <20150122185622.GE12911@leverpostej>
In-Reply-To: <20150122185622.GE12911@leverpostej>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2015 12:56 PM, Mark Rutland wrote:
> On Wed, Jan 21, 2015 at 05:56:37PM +0000, Suman Anna wrote:
>> On 01/21/2015 06:41 AM, Ohad Ben-Cohen wrote:
>>> On Tue, Jan 20, 2015 at 8:05 PM, Tony Lindgren <tony@atomide.com> wrote:
>>>> How about default to Linux id space and allow overriding that with
>>>> a module param option if needed?
>>>
>>> I'm not sure I'm following.
>>>
>>> If the main point of contention is the base_id field, I'm also fine
>>> with removing it entirely, as I'm not aware of any actual user for it
>>> (Suman please confirm?).
>>
>> Yeah, well the current implementations that I am aware of only have a
>> single bank, so all of them would be using a value of 0. I am yet to see
>> a platform with multiple instances where the property really makes a
>> difference. v7 has the property mandatory, so all the implementations
>> would need to define this value even if it is 0.
>>
>> regards
>> Suman
>>
>>>
>>> Mark? Rob? Will you accept Suman's patches if the base_id field is removed?
> 
> My concern is that the mapping of hwspinlock IDs doesn't seem to be
> explicit in the DT on a per-context basis, which is what I'd expect.
> 
> e.g.
> 
> lck: hwspinlock-device@f00 {
> 	...
> 	#hwlock-cells = <1>;
> };
> 
> some-other-os-interface {
> 	...
> 	hwlocks = <&lck 0>, <&lck 1>, <&lck 2>, <&lck 3>;
> 	hwlock-names = "glbl", "pool0", "pool1", "pool2";
> };
> 
> a-different-os-interface {
> 	...
> 	hwlocks = <&lck 18>, <&lck 21>, <&lck 4>, <&lck 5>;
> 	hwlock-names = "init", "teardown", "pool0", "pool1";
> };
> 
> That's the only way I would expect this to possibly remain a stable
> over time, and it's the entire reason for #hwlock-cells, no?
> 
> How do you expect the other components sharing the hwspinlocks to be
> described?

Yes indeed, this is what any of the clients will use on Linux. But this is not necessarily the semantics for exchanging hwlocks with the other processor(s) which is where the global id space comes into picture.

regards
Suman

