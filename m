Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776Ab3CTAcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:32:32 -0400
Received: from mail-ve0-f171.google.com ([209.85.128.171]:33617 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab3CTAca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:32:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
 <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
 <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com>
 <87hak8qfu5.fsf@rustcorp.com.au> <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 19 Mar 2013 20:32:09 -0400
Message-ID: <CALCETrVuoa32dx0ppvwQd+gty6WTVUzDU3f7Rwuge7GArDNU9Q@mail.gmail.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kbuild@vger.kernel.org, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 19, 2013 at 8:26 PM, Lucas De Marchi
<lucas.demarchi@profusion.mobi> wrote:
> Hi Rusty,
>
> On Mon, Mar 18, 2013 at 11:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>> Andy Lutomirski <luto@amacapital.net> writes:
>>> On Sun, Mar 17, 2013 at 7:24 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>>> On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>>>> Err, yes.  Don't remove module parameters, they're part of the API.  Do
>>>>>> you have a particular example?
>>>>>
>>>>> So things like i915.i915_enable_ppgtt, which is there to enable
>>>>> something experimental, needs to stay forever once the relevant
>>>>> feature becomes non-experimental and non-optional?  This seems silly.
>> ...
>>>>> Having the module parameter go away while still allowing the module to
>>>>> load seems like a good solution (possibly with a warning in the logs
>>>>> so the user can eventually delete the parameter).
>>>>
>>>> Why not do that for *every* missing parameter then?  Why have this weird
>>>> notation where the user must know that the parameter might one day go
>>>> away?
>>>
>>> Fair enough.  What about the other approach, then?  Always warn if an
>>> option doesn't match (built-in or otherwise) but load the module
>>> anyways.
>>
>> What does everyone think of this?  Jon, Lucas, does this match your
>> experience?
>>
>> Thanks,
>> Rusty.
>>
>> Subject: modules: don't fail to load on unknown parameters.
>>
>> Although parameters are supposed to be part of the kernel API, experimental
>> parameters are often removed.  In addition, downgrading a kernel might cause
>> previously-working modules to fail to load.
>
> I agree with this reasoning
>
>>
>> On balance, it's probably better to warn, and load the module anyway.
>
> However loading the module anyway would bring at least one drawback:
> if the user made a typo when passing the option the module would load
> anyway and he will probably not even look in the log, since there's
> was no errors from modprobe.
>
> For finit_module we could put a flag to trigger this behavior and
> propagate it to modprobe, but this is not possible with init_module().
> I can't think in any other option right now... do you have any?

Have a different finit_module return value for "successfully loaded,
but there were warnings" perhaps?

--Andy

>
>
> Lucas De Marchi



-- 
Andy Lutomirski
AMA Capital Management, LLC
