Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3JWBDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 21:03:34 -0400
Received: from smtp106.biz.mail.ne1.yahoo.com ([98.138.207.13]:28654 "HELO
	smtp106.biz.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754925Ab3JWBD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 21:03:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vDbE8TYVM1lXb1hGWZNmU97d3kP_wfExYHVMtBWIvbPyglj
 19fhbI2yKSsik6m6fGOLbOQHuv_cO.qLRc_RfG1PoeGwSudgxdaICgbwzzKw
 SArFZJfuXqu2QTzH2sjtBskl1lBoymKwFfX3iU7g.FlLN9ry_RxulIv3yOMU
 AkhTqC6z8n4xKSxiJSpAVRs.XowfQL1gu.KLu5rwFLxkL4.5tuN.A4vp5Xrb
 uqrC9n2hUaxDpq7sRLfcCPEnUkksioUu_Fy0OH7VbCwq_RlAss9byPc6zKdr
 F2PkDazyyaIj1JE4Wikz__jP1ljFKPlbdKhNcsXBSWGAGhQmzIPp3ZQr7cND
 vbvJ0dMoKRQwUINVO9BW9tJsfykuExUNTEoNXli0T7zHGklHFpLPpFwObF7l
 HHVXvH1pKYr0hXdxFcD13s_i.d1nVxQMNjfsYSh1rIfd5Q_BFy7Sk.h0Fg_k
 rN0r4vE7mIT5a6eQNY8AFAM_kesOg5RPV6RbMC4LrTKg6l28FPqzSOHmhHCA
 h7X6tBOEIZU68bmfdkUJxSatJzRmvb96.s39IAajNZ6JNVaFCEM.4we.5xcw
 .6nNMjsVz6e.LZ4lLRsV.Z060ldYccbmERz96LXQi6Cgw3WF37Dgth6lHKbV
 rCM6jziuR
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
X-Rocket-Received: from [192.168.0.103] (casey@67.180.103.242 with )
        by smtp106.biz.mail.ne1.yahoo.com with SMTP; 22 Oct 2013 18:03:24 -0700 PDT
Message-ID: <5267205C.7000304@schaufler-ca.com>
Date: Tue, 22 Oct 2013 18:03:24 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
References: <20130920203556.GA8726@www.outflux.net> <alpine.LRH.2.02.1310171858170.32257@tundra.namei.org> <52601DD8.7090308@schaufler-ca.com> <alpine.LRH.2.02.1310231047180.7063@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1310231047180.7063@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 5:02 PM, James Morris wrote:
> On Thu, 17 Oct 2013, Casey Schaufler wrote:
>
>> On 10/17/2013 1:02 AM, James Morris wrote:
>>> This seems like a regression in terms of separating mechanism and policy.  
>>>
>>> We have several access control systems available (SELinux, at least) which 
>>> can implement this functionality with existing mechanisms using dynamic 
>>> policy.
>> They said the same thing about Smack.
>>
> Nope.  Smack separates mechanism and policy.  The argument then was 
> whether we need more than one such enhanced access control system.
>
> The issue now is that we do have several of them (SELinux, Smack, 
> AppArmor) which are policy-flexible, whether to regress back to adding 
> hard-coded security policies into the kernel.
>
>> The problem there is that you have to buy into the entirety of
>> SELinux to implement a small bit of behavior. You have to write
>> a policy that takes every aspect of system behavior into account
>> when all you care about is loading restrictions on modules.
> You always need to consider the behavior of the system as a whole when 
> designing security policies.

This is right thinking. It's just not common thinking.

> It's a major step backwards to hard-code a series of ad-hoc policies in 
> the kernel.  You still need to compose them somehow, and reason about the 
> security of the system as a whole.

It's not like we're talking about throwing out the legacy monolithic LSMs.
And let us not forget that Fedora is using SELinux and Yama. There's a
perception of value in independent security mechanisms used in combination.

>> The rationale is that lots of people doing little things is
>> likely to get us relevant security in a reasonable amount of time.
>> The existing LSMs reflect 20th century technologies and use cases.
>> They are fine for multi-user timesharing systems. We need to move
>> forward to support networked gaming, phones, tablets and toasters.
> You keep making these grand

Cool! Most people use other, less complimentary adjectives!

> assertions but never provide any detail, or 
> any kind of evidence to back them up.

There are simple reasons for that. Between Tizen and the stacking patch
the work on a real Application+Service+Resource security model and the
implementation thereof has gotten insufficient attention. I have been
emphasizing work on enabling technology over work on what needs to be
enabled. Kees' approach to security development on CromeOS is the example
I'll hold up for the wave of the future.

> Yet there are many, many examples 
> of how the current LSMs meet all of these needs in the 21st century, such 
> as Smack being adopted for Tizen, digital television etc.:

Smack in Tizen is an example of old school distribution packaging.
Tizen is very old school in its approach. It's working out pretty
well, but Tizen is hardly a major advance in the world of OS security.

If you look at Android, their (re/miss/ab)use of the UID mechanism and
reliance on the binder to wedge an application based security policy
on top of existing mechanisms it should be pretty obvious that they
would have been better suited with new security features than with
retrofitting to existing technology.

SEAndroid is taking a refreshing approach by putting the access controls
in the middleware and by doing so enabling an appropriate implementation
on the flask architecture. I would not say that SEAndroid qualifies as an
example of adopting an LSM.

> http://en.wikipedia.org/wiki/Smack
>
>
>
> - James

