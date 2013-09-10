Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3IJDJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 23:09:17 -0400
Received: from mail.lang.hm ([64.81.33.126]:34248 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210Ab3IJDJP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 23:09:15 -0400
Date: Mon, 9 Sep 2013 20:09:05 -0700 (PDT)
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
In-Reply-To: <1378781715.17982.42.camel@x230.lan>
Message-ID: <alpine.DEB.2.02.1309092002060.1820@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>  <19562.1378747124@turing-police.cc.vt.edu>  <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>  <1378767723.17982.27.camel@x230.lan>  <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
  <1378774394.17982.36.camel@x230.lan>  <alpine.DEB.2.02.1309091938420.1820@nftneq.ynat.uz> <1378781715.17982.42.camel@x230.lan>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013, Matthew Garrett wrote:

> On Mon, 2013-09-09 at 19:44 -0700, David Lang wrote:
>> On Tue, 10 Sep 2013, Matthew Garrett wrote:
>>> No. Say someone adds an additional lockdown bit to forbid raw access to
>>> mounted block devices. The "Turn everything off" approach now means that
>>> I won't be able to perform raw access to mounted block devices, even if
>>> that's something that my use case relies on.
>>
>> I was meaning that if you only turn off features that you know about, the
>> addition of a new thing that can be disabled doesn't make you any worse off than
>> you were.
>
> Someone adds a new "install_evil()" syscall and adds a disable bit. If I
> don't disable it, I'm now vulnerable. Please pay attention to earlier
> discussion.

so instead they add install_evil() and don't have it be disabled by your big 
switch.

or do you think the existance of this switch will give you veto power over any 
new system calls unless they include the ability for them to be disabled if they 
don't match your security model.

>>>> so if you only have a single bit, how do you deal with the case where that bit
>>>> locks down something that's required? (your reason for not just setting all bits
>>>> in the first approach)
>>>
>>> Because that bit is well-defined, and if anything is added to it that
>>> doesn't match that definition then it's a bug.
>>
>> it may be well defined, but that doesn't mean that it actually matches what the
>> system owner wants to do.
>
> If it doesn't match what the system owner wants to do, the system owner
> doesn't set it. The system owner uses a more appropriate security
> mechanism instead.

SELinux is a wonderful example of how making a system that users cannot change 
doesn't improve security, it just gets disabled instead.

>> The idea that the programmer can possibly anticipate all possible needs and
>> provide a switch for exactly that need is just wrong. Users will have needs that
>> you never thought of. The best systems are the ones where the creators look at
>> what users are doing and react with "I never imagined doing that"
>
> Describe the security case for disabling PCI BAR access but permitting
> i/o port access.

Simple, I have some device that lives on those I/O ports that I want to be able 
to use.

>>> Anything more granular means that you trust your userspace, and if you
>>> trust your userspace then you can already set up a granular policy using
>>> the existing tools for that job. So just use the existing tools.
>>
>> If you can't trust your userspace, how do you know that the userspace has set
>> the big hammer flag in the first place? if you can trust it to throw that
>> switch, you can trust it to throw multiple smaller switches.
>
> Hence the final patch in the series, and hence also the suggestion for
> exposing it as a command line option that can be set by the bootloader
> during an attested boot.
>
>>>> And if SELinux can do the job, what is the reason for creating this new option?
>>>
>>> Because you can't embed an unmodifiable selinux policy in the kernel.
>>
>> Why not, have the policy set in an initramfs that's part of the kernel and have
>> part of that policy be to block all access to the selinux controls.
>
> Because then someone disables selinux on the kernel command line.

If they can modify the command line, they can remove your command line switch to 
turn this on.

If you really care about this, why are you using a bootloader that lets you 
modify the kernel command line in the first place?

In any case, even if you make it impossible to change from the command line, you 
won't prevent people from changing your system (unless you take control 
completely away from them with TPM or similar)

remember that the system integrity checking of the original Tivo was defeated by 
someone dong a binary patch to bypass a routine that they didn't understand that 
took a lot of time, so they did a binary patch to the bios to speed up boot and 
discovered that what they did was disable the system integrity checking.

users who own the systems are going to modify them and bypass any restrictions 
you want to impose.

users who don't own the systems can be defeated by simply not offering them the 
option to change the settings in the first place.

David Lang
