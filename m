Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbbAVS4z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:56:55 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41197 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbbAVS4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:56:51 -0500
Date: Thu, 22 Jan 2015 18:56:22 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Suman Anna <s-anna@ti.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <robherring2@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Bjorn Andersson <bjorn@kryo.se>,
        Josh Cartwright <joshc@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v7 1/4] Documentation: dt: add common bindings for
 hwspinlock
Message-ID: <20150122185622.GE12911@leverpostej>
References: <1421269101-51105-2-git-send-email-s-anna@ti.com>
 <20150115135201.GG16217@leverpostej>
 <20150115135556.GH16217@leverpostej>
 <CAL_JsqL2LZAooMk-V8+xeF2g6acZE21M+-OBRw8aEVa-5wVHuQ@mail.gmail.com>
 <CAK=WgbYQ=BbinqJ5fsw2Y+FKdy=nasLsw9mX8pw6S_o3owy9-g@mail.gmail.com>
 <20150116101746.GA21809@leverpostej>
 <CAK=WgbYBqPoUm9byx0du_g5ZmHdYaUVLpSPZYHoCVzNoatNKpw@mail.gmail.com>
 <20150120180548.GK7718@atomide.com>
 <CAK=WgbZGGtwmQwzWumjpYOsYHTt8vPQpTraABwJBsv5VXOmJ_Q@mail.gmail.com>
 <54BFE855.3090200@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BFE855.3090200@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 21, 2015 at 05:56:37PM +0000, Suman Anna wrote:
> On 01/21/2015 06:41 AM, Ohad Ben-Cohen wrote:
> > On Tue, Jan 20, 2015 at 8:05 PM, Tony Lindgren <tony@atomide.com> wrote:
> >> How about default to Linux id space and allow overriding that with
> >> a module param option if needed?
> > 
> > I'm not sure I'm following.
> > 
> > If the main point of contention is the base_id field, I'm also fine
> > with removing it entirely, as I'm not aware of any actual user for it
> > (Suman please confirm?).
> 
> Yeah, well the current implementations that I am aware of only have a
> single bank, so all of them would be using a value of 0. I am yet to see
> a platform with multiple instances where the property really makes a
> difference. v7 has the property mandatory, so all the implementations
> would need to define this value even if it is 0.
> 
> regards
> Suman
> 
> > 
> > Mark? Rob? Will you accept Suman's patches if the base_id field is removed?

My concern is that the mapping of hwspinlock IDs doesn't seem to be
explicit in the DT on a per-context basis, which is what I'd expect.

e.g.

lck: hwspinlock-device@f00 {
	...
	#hwlock-cells = <1>;
};

some-other-os-interface {
	...
	hwlocks = <&lck 0>, <&lck 1>, <&lck 2>, <&lck 3>;
	hwlock-names = "glbl", "pool0", "pool1", "pool2";
};

a-different-os-interface {
	...
	hwlocks = <&lck 18>, <&lck 21>, <&lck 4>, <&lck 5>;
	hwlock-names = "init", "teardown", "pool0", "pool1";
};

That's the only way I would expect this to possibly remain a stable
over time, and it's the entire reason for #hwlock-cells, no?

How do you expect the other components sharing the hwspinlocks to be
described?

Thanks,
Mark.
