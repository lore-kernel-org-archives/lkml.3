Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759635Ab3CGRxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 12:53:53 -0500
Received: from mail-vc0-f178.google.com ([209.85.220.178]:60455 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab3CGRxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 12:53:51 -0500
MIME-Version: 1.0
In-Reply-To: <20130307155343.GD2790@redhat.com>
References: <20130304191546.GF15199@redhat.com>
	<1362446491.4392.133.camel@falcor1>
	<20130305151829.GB4519@redhat.com>
	<1362516018.4392.233.camel@falcor1>
	<20130305215300.GE4519@redhat.com>
	<1362584551.4392.291.camel@falcor1>
	<20130306235525.GB29229@redhat.com>
	<1362620348.4392.408.camel@falcor1>
	<20130307143643.GA2790@redhat.com>
	<1362670833.4392.438.camel@falcor1>
	<20130307155343.GD2790@redhat.com>
Date: Thu, 7 Mar 2013 19:53:50 +0200
Message-ID: <CALLzPKYTmD2AUm1k7JEzXupRjOUPgkQ0LRpuT7b5P1yNpLQOxg@mail.gmail.com>
Subject: Re: IMA: How to manage user space signing policy with others
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Eric Paris <eparis@parisplace.org>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 5:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 07, 2013 at 10:40:33AM -0500, Mimi Zohar wrote:
>> On Thu, 2013-03-07 at 09:36 -0500, Vivek Goyal wrote:
>> > On Wed, Mar 06, 2013 at 08:39:08PM -0500, Mimi Zohar wrote:
>> > > On Wed, 2013-03-06 at 18:55 -0500, Vivek Goyal wrote:
>> > > > On Wed, Mar 06, 2013 at 10:42:31AM -0500, Mimi Zohar wrote:
>> >
>> > > Adding an IMA call to directly appraise the integrity of a file, rather
>> > > than adding a hook, prevents other integrity users from being able to
>> > > define a rule at that point.
>> >
>> > We already have security hooks in exec() code and mmap(). And current
>> > integrity callers are happy with it.
>>
>> Exposing integrity calls, resolves the problem of code duplication, but
>> does not address Rusty's third issue of improving the integrity
>> subsystem.
>
> I thought rusty wanted me to reuse existing integrity code so that there
> is no code duplication. And improve things as needed int the process
> so meet new requirements.
>
> And exposing functions calls will just do that. Improve IMA so that
> more people can reuse the same code without breaking existing users.
>
> Other improvements will be to improve "cpio" to support xattr and
> figure a way out to chain into secureboot root of trust and load
> only trusted keys.
>
> So yes, I am improving IMA subsystem. Only thing I am arguing against
> that I don't think trying to enahnce policy based interface is right
> thing to do here in the light of new requirements. It just makes IMA too
> complicated and it is not worth it.
>
>>  You have no idea if the existing integrity users are happy
>> with the status quo.
>
> If nobody is speaking then I have to assume something. If they are happy,
> great, exposing new functions are not going to break any of their
> functionality. If they are not happy then there is more reason to believe
> that trying to enahance policy based interface is a bad thing. It is not
> working.
>
>>  It's there and they're using it.  They could want
>> additional hooks or better located hooks.  Each of your complaints about
>> the integrity subsystem could be addressed and would improve the
>> subsystem.
>
> If they want better located hooks, they are more than welcome to put
> it. Exposing some of the functions does not prevent it. They want
> to improve IMA subsystem, sure, why not. Exposing some fucntions
> does not prevent it.
>

Hello,

Sorry if missed something from this lengthy thread and I repeat something.

I have not noticed what functions you propose to export.

But for your use case you need to know if file was signed and
signature was fine, right?
So you want to export a function which returns, for example
"iint->flags & IMA_DIGSIG".
If it was no xattr or no signature, then this flag will not be set.
If signature verification failed, then hook returns EPERM anyway.

Is it what you want?

- Dmitry

> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
