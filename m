Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab3IJCpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 22:45:05 -0400
Received: from mail.lang.hm ([64.81.33.126]:33331 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753624Ab3IJCpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 22:45:02 -0400
Date: Mon, 9 Sep 2013 19:44:38 -0700 (PDT)
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
In-Reply-To: <1378774394.17982.36.camel@x230.lan>
Message-ID: <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <19562.1378747124@turing-police.cc.vt.edu>  <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>  <1378767723.17982.27.camel@x230.lan>  <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
 <1378774394.17982.36.camel@x230.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Matthew Garrett wrote:

> On Mon, 2013-09-09 at 16:19 -0700, David Lang wrote:
>> On Mon, 9 Sep 2013, Matthew Garrett wrote:
>>> Having thought about this, the answer is no. It presents exactly the
>>> same problem as capabilities do - the set can never be meaningfully
>>> extended. If an application sets only the bits it knows about, and if a
>>> new security-sensitive feature is added to the kernel, the feature will
>>> be left enabled and the system will be insecure. Alternatively, if an
>>> application sets all the bits regardless of whether it knows them or
>>> not, it may enable a lockdown feature that it otherwise required.
>>
>> In this case you are no less secure than you were before the feature was added,
>> you just can't take advantage of the new feature without updating userspace.
>
> No. Say someone adds an additional lockdown bit to forbid raw access to
> mounted block devices. The "Turn everything off" approach now means that
> I won't be able to perform raw access to mounted block devices, even if
> that's something that my use case relies on.

I was meaning that if you only turn off features that you know about, the 
addition of a new thing that can be disabled doesn't make you any worse off than 
you were.

>>> The only way this is useful is if all the bits are semantically
>>> equivalent, and in that case there's no point in having anything other
>>> than a single bit. Users who want a more fine-grained interface should
>>> use one of the existing mechanisms for doing so - leave the kernel open
>>> and impose the security policy from userspace using either capabilities
>>> or selinux.
>>
>> so if you only have a single bit, how do you deal with the case where that bit
>> locks down something that's required? (your reason for not just setting all bits
>> in the first approach)
>
> Because that bit is well-defined, and if anything is added to it that
> doesn't match that definition then it's a bug.

it may be well defined, but that doesn't mean that it actually matches what the 
system owner wants to do.

The idea that the programmer can possibly anticipate all possible needs and 
provide a switch for exactly that need is just wrong. Users will have needs that 
you never thought of. The best systems are the ones where the creators look at 
what users are doing and react with "I never imagined doing that"

defining the "one true way" of operating is just wrong.

>> your arguments don't seem self consistent.
>
> You don't seem to have been paying attention to the past 12 months of
> discussion.
>
>> If I'm building a kiosk PC (or voting machine), I want to disable a lot of
>> things that I could not get away with disabling on a generic laptop. Are we
>> going to have Securelevel, ReallySecurelevel, ReallyReallySecurelevel, etc? or
>> can we accept that security is not binary and allow users to disable features
>> in a more granualar way?
>
> Anything more granular means that you trust your userspace, and if you
> trust your userspace then you can already set up a granular policy using
> the existing tools for that job. So just use the existing tools.

If you can't trust your userspace, how do you know that the userspace has set 
the big hammer flag in the first place? if you can trust it to throw that 
switch, you can trust it to throw multiple smaller switches.

>> And if SELinux can do the job, what is the reason for creating this new option?
>
> Because you can't embed an unmodifiable selinux policy in the kernel.

Why not, have the policy set in an initramfs that's part of the kernel and have 
part of that policy be to block all access to the selinux controls.

David Lang
