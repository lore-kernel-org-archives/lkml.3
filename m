Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819Ab3CRRmr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:42:47 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60644 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3CRRmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <87sj3tsawh.fsf@rustcorp.com.au>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
 <87ehfhtftn.fsf@rustcorp.com.au> <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
 <87sj3tsawh.fsf@rustcorp.com.au>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 18 Mar 2013 13:42:23 -0400
Message-ID: <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        linux-kbuild@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 7:24 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
>> On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>> Andy Lutomirski <luto@amacapital.net> writes:
>>>> Current parameter behavior is odd.  Boot parameters that have values
>>>> and don't match anything become environment variables, with no
>>>> warning.  Boot parameters without values that don't match anything
>>>> go into argv_init.  Everything goes into /proc/cmdline.
>>>>
>>>> The init_module and finit_module syscalls, however, are strict:
>>>> parameters that don't match result in -ENOENT.
>>>>
>>>> kmod (and hence modprobe), when loading a module called foo, look in
>>>> /proc/cmdline for foo.x or foo.x=y, strip off the foo., and pass the
>>>> rest to init_module.
>>>>
>>>> The upshot is that booting with module.nonexistent_parameter=1 is
>>>> okay if module is built in or missing entirely but prevents module
>>>> from loading if it's an actual module.  Similarly, option module
>>>> nonexistent_parameter=1 in /etc/modprobe.d prevents the module from
>>>> loading the parameter goes away.  This means that removing module
>>>> parameters unnecessarily breaks things.
>>>
>>> Err, yes.  Don't remove module parameters, they're part of the API.  Do
>>> you have a particular example?
>>
>> So things like i915.i915_enable_ppgtt, which is there to enable
>> something experimental, needs to stay forever once the relevant
>> feature becomes non-experimental and non-optional?  This seems silly.
>
> Well, it's either experimental, in which case you're happy to break
> users who use it, or it's not, in which case, don't.

Sure.  The main issue for me annoyance.  Install kernel with
experimental option.  Set that option in grub's config.  Boot another
kernel.  Grr, the option got propagated there and now I have no
graphics.

>
>> Having the module parameter go away while still allowing the module to
>> load seems like a good solution (possibly with a warning in the logs
>> so the user can eventually delete the parameter).
>
> Why not do that for *every* missing parameter then?  Why have this weird
> notation where the user must know that the parameter might one day go
> away?

Fair enough.  What about the other approach, then?  Always warn if an
option doesn't match (built-in or otherwise) but load the module
anyways.

--Andy
