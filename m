Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3IIXU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 19:20:56 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:63638 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755729Ab3IIXUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 19:20:54 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com>
	<19562.1378747124@turing-police.cc.vt.edu>
	<alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz>
	<1378767723.17982.27.camel@x230.lan>
	<alpine.DEB.2.02.1309091614010.2479@nftneq.ynat.uz>
Date: Mon, 9 Sep 2013 16:20:53 -0700
X-Google-Sender-Auth: w6NAmK9lw1NJ81nG6XB5IA2ePjM
Message-ID: <CAGXu5jJdMXP84TPP-=dtExFkpcGKPGLWnOu1-PZMokz5WhCLwQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
From: Kees Cook <keescook@chromium.org>
To: David Lang <david@lang.hm>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 9, 2013 at 4:19 PM, David Lang <david@lang.hm> wrote:
> On Mon, 9 Sep 2013, Matthew Garrett wrote:
>
>> On Mon, 2013-09-09 at 11:25 -0700, David Lang wrote:
>>
>>> 1 lock down modules
>>> 2 lock down kexec
>>
>>
>> Having thought about this, the answer is no. It presents exactly the
>> same problem as capabilities do - the set can never be meaningfully
>> extended. If an application sets only the bits it knows about, and if a
>> new security-sensitive feature is added to the kernel, the feature will
>> be left enabled and the system will be insecure. Alternatively, if an
>> application sets all the bits regardless of whether it knows them or
>> not, it may enable a lockdown feature that it otherwise required.
>
>
> In this case you are no less secure than you were before the feature was
> added, you just can't take advantage of the new feature without updating
> userspace.
>
> That's a very common situation
>
>
>> The only way this is useful is if all the bits are semantically
>> equivalent, and in that case there's no point in having anything other
>> than a single bit. Users who want a more fine-grained interface should
>> use one of the existing mechanisms for doing so - leave the kernel open
>> and impose the security policy from userspace using either capabilities
>> or selinux.
>
>
> so if you only have a single bit, how do you deal with the case where that
> bit locks down something that's required? (your reason for not just setting
> all bits in the first approach)
>
> your arguments don't seem self consistent.
>
>
> why should there only be one way to lock down a system? there are lots of
> different use cases.
>
> If I'm building a kiosk PC (or voting machine), I want to disable a lot of
> things that I could not get away with disabling on a generic laptop. Are we
> going to have Securelevel, ReallySecurelevel, ReallyReallySecurelevel, etc?
> or can we accept that security is not binary and allow users to disable
> features in a more granualar way?
>
> And if SELinux can do the job, what is the reason for creating this new
> option?

Not everyone uses SELinux. :) Also, it's rarely controlled the things
we want to control here.

-Kees

-- 
Kees Cook
Chrome OS Security
