Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755639Ab3IIUAV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:00:21 -0400
Received: from mail.lang.hm ([64.81.33.126]:50584 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754425Ab3IIUAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:00:17 -0400
Date: Mon, 9 Sep 2013 12:59:50 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Matthew Garrett <matthew.garrett@nebula.com>
cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
In-Reply-To: <1378753619.17982.16.camel@x230.lan>
Message-ID: <alpine.DEB.2.02.1309091247340.2479@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <19562.1378747124@turing-police.cc.vt.edu>  <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>  <1378751318.17982.10.camel@x230.lan>  <alpine.DEB.2.02.1309091139490.2479@nftneq.ynat.uz>
  <1378752158.17982.15.camel@x230.lan>  <alpine.DEB.2.02.1309091150570.2479@nftneq.ynat.uz> <1378753619.17982.16.camel@x230.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Matthew Garrett wrote:

> On Mon, 2013-09-09 at 11:53 -0700, David Lang wrote:
>
>> So is there a way to unify these different things rather than creating yet
>> another different knob?
>
> We haven't found one that people consider generally acceptable.

At least you should be able to unify the implementation, even if you don't unify 
the user visible knob

If you do this with a capabilities approach, then you can implement the 'only 
load signed modules' bit and then have that bit call the existing kernel code, 
or change that existing kernel code to internally set the capabilities bit.

I see you looking for two key things

1. a sledgehammer to say "I want to be as secure as possible"

2. no way to unset the setting (barring kernel bugs/vulnerabilities)

implementing this as capabilities will still let you meet your goals, just have 
your tools that lock things down set the value to -1 (all 1's)

As long as a bit cannot be unset, only set, it still satisfies your second 
requirement to not be able to back out.

And for people who want a partial lockdown, the various capabilities bits allow 
them to get the amount of lockdown that they want.

but if you are really trying to lock down a system, there are things that you 
want to do that will break normal users (things like disabling all module 
loading, disabling mounting of filesystems, disable the connection of new USB 
devices, etc)

These are good tools to have available, but since using them will break some 
normal use cases, you really do want to be able to enable some things without 
enabling others.

What you are seeing in this discussion is that even for the set of things that 
you consider 'essential' to lock down, other people see valid cases to not lock 
them down.

If your tools only set 'known' or 'allocated' bits, you run the risk of not 
locking things down as tightly as you could, but if new bits are only allocated 
for new lockdown features, this is not a regression since you are no worse off 
than you would have been with an old kernel.


Since we are not talking POSIX capabilities here, we are talking 'secure the 
system from even root' capabilities, there is no other system that we need to 
copy. The BSD securelevel approach is a simple big hammer approach, and it's 
easy to emulate with capabilities.

David Lang
