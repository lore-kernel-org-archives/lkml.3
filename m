Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934319Ab3CTA02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:26:28 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:63100 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295Ab3CTA00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:26:26 -0400
MIME-Version: 1.0
In-Reply-To: <87hak8qfu5.fsf@rustcorp.com.au>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
 <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
 <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com>
 <87hak8qfu5.fsf@rustcorp.com.au>
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 19 Mar 2013 21:26:04 -0300
Message-ID: <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kbuild@vger.kernel.org, Jon Masters <jcm@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

On Mon, Mar 18, 2013 at 11:32 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>> On Sun, Mar 17, 2013 at 7:24 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>> On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>>>> Err, yes.  Don't remove module parameters, they're part of the API.  Do
>>>>> you have a particular example?
>>>>
>>>> So things like i915.i915_enable_ppgtt, which is there to enable
>>>> something experimental, needs to stay forever once the relevant
>>>> feature becomes non-experimental and non-optional?  This seems silly.
> ...
>>>> Having the module parameter go away while still allowing the module to
>>>> load seems like a good solution (possibly with a warning in the logs
>>>> so the user can eventually delete the parameter).
>>>
>>> Why not do that for *every* missing parameter then?  Why have this weird
>>> notation where the user must know that the parameter might one day go
>>> away?
>>
>> Fair enough.  What about the other approach, then?  Always warn if an
>> option doesn't match (built-in or otherwise) but load the module
>> anyways.
>
> What does everyone think of this?  Jon, Lucas, does this match your
> experience?
>
> Thanks,
> Rusty.
>
> Subject: modules: don't fail to load on unknown parameters.
>
> Although parameters are supposed to be part of the kernel API, experimental
> parameters are often removed.  In addition, downgrading a kernel might cause
> previously-working modules to fail to load.

I agree with this reasoning

>
> On balance, it's probably better to warn, and load the module anyway.

However loading the module anyway would bring at least one drawback:
if the user made a typo when passing the option the module would load
anyway and he will probably not even look in the log, since there's
was no errors from modprobe.

For finit_module we could put a flag to trigger this behavior and
propagate it to modprobe, but this is not possible with init_module().
I can't think in any other option right now... do you have any?


Lucas De Marchi
