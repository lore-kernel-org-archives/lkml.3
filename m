Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab3IIUKg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 16:10:36 -0400
Received: from mail.lang.hm ([64.81.33.126]:47728 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752574Ab3IIUKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 16:10:32 -0400
Date: Mon, 9 Sep 2013 13:10:26 -0700 (PDT)
From: David Lang <david@lang.hm>
X-X-Sender: dlang@asgard.lang.hm
To: Josh Boyer <jwboyer@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 00/12] One more attempt at useful kernel lockdown
In-Reply-To: <CA+5PVA4mu=ykBMgWYaEagCsDexR-qFYH0tfjK+4B+xOCPonNXg@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1309091300420.2479@nftneq.ynat.uz>
References: <1378741786-18430-1-git-send-email-matthew.garrett@nebula.com> <19562.1378747124@turing-police.cc.vt.edu> <alpine.DEB.2.02.1309091119330.2479@nftneq.ynat.uz> <27562.1378753264@turing-police.cc.vt.edu> <522E2487.90109@zytor.com>
 <CA+5PVA4mu=ykBMgWYaEagCsDexR-qFYH0tfjK+4B+xOCPonNXg@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Sep 2013, Josh Boyer wrote:

> On Mon, Sep 9, 2013 at 3:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> On 09/09/2013 12:01 PM, Valdis.Kletnieks@vt.edu wrote:
>>> On Mon, 09 Sep 2013 11:25:38 -0700, David Lang said:
>>>
>>>> Given that we know that people want signed binaries without
>>>> blocking kexec, you should have '1' just enforce module signing
>>>> and '2' (or higher) implement a full lockdown including kexec.
>>>
>>>> Or, eliminate the -1  permanently insecure option and make this a
>>>> bitmask, if someone wants to enable every possible lockdown, have
>>>> them set it to "all 1's", define the bits only as you need them.
>>>
>>> This strikes me as much more workable than one big sledgehammer.
>>>
>>
>> I.e. capabilities ;)
>
> Circles.  All I see here are circles.

the thing is that these are not circles. they are separate orthoginal things 
that you may or may not want to allow.

If this was a simple set of circles, then this could be defined as a vector 
instead of bitmap, the further you go the more secure you are.

But there are always going to be cases where you want to keep most of the 
lockdown, but relax just one specific aspect of it, so you want it to be a 
bitmap instead nested circles.

Now, I know that some people are going to argue that if you relax one portion 
you have a hole in your secureity so it's not worth having any security at all. 
but I've been doing security for banks for the last 16 years and I can say that 
security is not a binary thing, just because there is one hole it isn't 
worthless to close another one. Attackers are not omnificent, they don't know 
everything there is to know about your system. If you block some holes you will 
make those attaches worthless. some holes you need to leave open to avoid 
breaking the business, and you either mitigate the risk in other ways (as 
discussed in this thread, by only loading modules from media that was tested to 
be intact, even if they aren't signed), or you accept that risk and factor the 
cost of cleanup into your cusiness plans.

David Lang

> Having lived an entire release with a capabilities based mechanism for
> this in Fedora, please no.
>
> And if you are talking about non-POSIX capabilities as you mentioned
> earlier, that seems to be no different than having securelevel being a
> bitmask of, well, levels.  I don't have much opinion on securelevel
> being a big hammer or a bitmask of finer grained things, but I do
> think it's a more manageable way forward.  Calling the implementation
> "capabilities" seems to just be unnecessarily confusing.
>
> josh
>
