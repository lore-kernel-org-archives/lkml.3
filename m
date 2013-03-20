Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044Ab3CTF1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 01:27:14 -0400
Received: from ozlabs.org ([203.10.76.45]:57381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab3CTF1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 01:27:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Andy Lutomirski <luto@amacapital.net>, linux-kernel@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        linux-kbuild@vger.kernel.org, Jon Masters <jcm@redhat.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
In-Reply-To: <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net> <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com> <87sj3tsawh.fsf@rustcorp.com.au> <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com> <87hak8qfu5.fsf@rustcorp.com.au> <CAMOw1v5AOmy38KNVfxj6OO-U0UCXST50vD0g0W5fEpNfKCpGvg@mail.gmail.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 20 Mar 2013 14:15:12 +1030
Message-ID: <87sj3qpwdz.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lucas De Marchi <lucas.demarchi@profusion.mobi> writes:
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

No good ones :(

MODULE_PARM_DESC isn't compulsory, so you can't rely on that to tell you
about option names.  

Even if we had a flag, how would you know to set it?  I guess you could
try without then try with, and if it works the second time print a
warning about typos.  But it's still pretty ugly.

We could implement such a flag with a fake "IGNORE_BAD_PARAMS"
parameter, for example.  That would fail nicely on older kernels, too.

Hmmm....
Rusty.
