Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab3JQVKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:10:03 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43041 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932148Ab3JQVJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:09:57 -0400
MIME-Version: 1.0
In-Reply-To: <52601DD8.7090308@schaufler-ca.com>
References: <20130920203556.GA8726@www.outflux.net>
	<alpine.LRH.2.02.1310171858170.32257@tundra.namei.org>
	<52601DD8.7090308@schaufler-ca.com>
Date: Thu, 17 Oct 2013 14:09:56 -0700
X-Google-Sender-Auth: vJTpX5KzhtPEGy_Huntb_qo0OZU
Message-ID: <CAGXu5jK4wM2oD89HQ4Yx+YG9VNQm0Pnyx1bGt3irkw7NVkQHYA@mail.gmail.com>
Subject: Re: [PATCH] LSM: ModPin LSM for module loading restrictions
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, LKML <linux-kernel@vger.kernel.org>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 10:26 AM, Casey Schaufler
<casey@schaufler-ca.com> wrote:
> On 10/17/2013 1:02 AM, James Morris wrote:
>> This seems like a regression in terms of separating mechanism and policy.
>>
>> We have several access control systems available (SELinux, at least) which
>> can implement this functionality with existing mechanisms using dynamic
>> policy.
>
> They said the same thing about Smack.
>
> The problem there is that you have to buy into the entirety of
> SELinux to implement a small bit of behavior. You have to write
> a policy that takes every aspect of system behavior into account
> when all you care about is loading restrictions on modules.
>
> If you want all of SELinux you still have to define your problem
> in a subject/object model. That may be possible, but in this
> case at least it certainly ain't obvious.
>
>> I'm concerned about the long term architectural impact of a proliferation
>> of arbitrary hard-coded security policies in the kernel.  I don't
>> understand the push in this direction, frankly.
>
> The rationale is that lots of people doing little things is
> likely to get us relevant security in a reasonable amount of time.
> The existing LSMs reflect 20th century technologies and use cases.
> They are fine for multi-user timesharing systems. We need to move
> forward to support networked gaming, phones, tablets and toasters.

I, obviously, agree with with this. At least with Chrome OS, we've
been taking an architectural approach to security. Our trust model is
based on very different ways of doing things, and this results in
needing to trust things that are not part of the traditional
subject/object model, IMO. We trust the contents of our root
filesystem, so there's no need to do things like module signing, etc.
In many ways, IMA follows similar approaches but at a different layer
(i.e. we use dm-verity).

Chrome OS has been using this LSM for about a year now. It provides
demonstrably improved security since it draws a bright line between
uid-0 and ring-0 on systems that have a verified boot path but use
kernel modules.

-Kees

-- 
Kees Cook
Chrome OS Security
