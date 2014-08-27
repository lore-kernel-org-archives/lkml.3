Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752451AbaH0HQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 03:16:53 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:43522 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbaH0HQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 03:16:51 -0400
Message-ID: <53FD85C7.4080900@ahsoftware.de>
Date: Wed, 27 Aug 2014 09:16:23 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Jon Loeliger <jdl@jdl.com>
CC: Thierry Reding <thierry.reding@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver initialization
 order based on the DT)
References: <20140825093931.GB2399@ulmo> <E1XLu15-0002DP-6o@jdl.com> <20140825133714.GH4163@ulmo.nvidia.com> <20140826084208.AE5F0C40989@trevor.secretlab.ca> <20140826084922.GG17263@ulmo> <53FC566C.30904@ahsoftware.de> <20140826102503.GC31124@ulmo> <53FC6513.5040800@ahsoftware.de> <20140826110827.GA31350@ulmo> <53FC6E4A.6030407@ahsoftware.de> <20140826114718.GB641@ulmo> <53FC76E8.5050009@ahsoftware.de> <E1XMHGc-0008TS-CQ@jdl.com>
In-Reply-To: <E1XMHGc-0008TS-CQ@jdl.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.08.2014 15:58, schrieb Jon Loeliger:

> I think we need to do the complete topsort *before* we attempt
> to do any probing.  So three steps:
>
>     1) Graph Construction
>         Add a new "emit dependencies" function to driver bindings.
>         Iterate over known devices or nodes in the DT in any order.
> 	    Call the "emit dependencies" function.  It adds all
> 	    dependency edges to a global graph by knowing what
> 	    phandles or other pieces it will need.
> 	    A driver with no "emit dependencies" function can be
> 	    added to the graph anywhere without loss of generality.
>         Add any additional edges for whatever reason.
>
>     2) Topsort the generated driver graph
>
>     3) Call probe for real in topsort order
>
> Alexander, I don't recall the details of your patch series.
> Can you please remind us if it took this approach in the kernel?
>
>> Anyway, I'm leaving this discussion. I've already made a proposal
>> which solved most mentioned problems (imho) and even offered usable
>> patches

Why should I? I've posted patches along with a lot of comments and
explanations, and e.g. you are just talking that it should be made like
my patches already did. And others do talk too like my patches and the
accompanying comments from me which explain most stuff never have 
existed and just repeat what the patches already do without refering to 
them.

> Darn.  I think you clearly have a pony in this race, and it
> would be good if you still participated.  Really.

Thanks. But I don't see it as a race and I don't want to take part in a 
race (and I usually avoid those silly contests which have become chic in 
the IT world). I just offered a solution (or at least a working starting 
point to a solution).

>> (ok, they suffer under the "not invented here" syndrom, but ...). ;)
>
> There isn't a single thing in the entire Linux Kernel community
> that was "invented here"; every aspect of it was NIH'ed by *someone*.
> That's how it gets built, changed, maintained, fixed, etc.

Might be true in an ideal open source world and might have been true for 
past kernel development when most people weren't full time kernel 
developers. But nowadays it appears to me like many parts of the kernel 
have become in the hands of closed groups. And they build and enforce 
hurdles that high, that nobody else can take them without spending an 
idiotic amount of time. Just like many other "consortiums" do, you only 
have to build enough rules to protect from the outside while still 
looking open.

E.g. an example I've seen often is that someone spend a lot of time to 
examine and fix a bug and write a commented patch. And the only response 
from the maintainer was that he should add an emtpy line before a return 
statement and similiar silly things to enforce patch-ping-pong. Such 
just drives people on the other end crazy and they likely won't spend 
the time to post another patch (they still might  fix other bugs, but 
just for themself).

Regards,

Alexander Holler
