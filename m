Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab3CSTk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 15:40:57 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:40303 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab3CSTkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 15:40:55 -0400
Message-ID: <1363722051.3491.29.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH] Allow optional module parameters
From: Ben Hutchings <bhutchings@solarflare.com>
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Andy Lutomirski <luto@amacapital.net>, <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>, Jon Masters <jcm@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Date: Tue, 19 Mar 2013 19:40:51 +0000
In-Reply-To: <87hak8qfu5.fsf@rustcorp.com.au>
References: <b6b1676fd5bcd6b0ef47b0e0a1c26b1c05684135.1363291511.git.luto@amacapital.net>
	 <87ehfhtftn.fsf@rustcorp.com.au>
	 <CALCETrU+rehQzy4vVg589CGi561X_s73Xgsfp43pYZOoKvNDXQ@mail.gmail.com>
	 <87sj3tsawh.fsf@rustcorp.com.au>
	 <CALCETrUK54KViGex=V2pG8kAttsxOiDkeJUL48pk1NAhH-SdAA@mail.gmail.com>
	 <87hak8qfu5.fsf@rustcorp.com.au>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19730.001
X-TM-AS-Result: No--28.807600-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 13:02 +1030, Rusty Russell wrote:
> Andy Lutomirski <luto@amacapital.net> writes:
> > On Sun, Mar 17, 2013 at 7:24 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> Andy Lutomirski <luto@amacapital.net> writes:
> >>> On Thu, Mar 14, 2013 at 10:03 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >>>> Err, yes.  Don't remove module parameters, they're part of the API.  Do
> >>>> you have a particular example?
> >>>
> >>> So things like i915.i915_enable_ppgtt, which is there to enable
> >>> something experimental, needs to stay forever once the relevant
> >>> feature becomes non-experimental and non-optional?  This seems silly.
> ...
> >>> Having the module parameter go away while still allowing the module to
> >>> load seems like a good solution (possibly with a warning in the logs
> >>> so the user can eventually delete the parameter).
> >>
> >> Why not do that for *every* missing parameter then?  Why have this weird
> >> notation where the user must know that the parameter might one day go
> >> away?
> >
> > Fair enough.  What about the other approach, then?  Always warn if an
> > option doesn't match (built-in or otherwise) but load the module
> > anyways.
> 
> What does everyone think of this?  Jon, Lucas, does this match your
> experience?

I'm not sure why I'm being cc'd on this, though I did recently remove a
module parameter (sfc.rx_alloc_method).  For what it's worth:

> Subject: modules: don't fail to load on unknown parameters.
> 
> Although parameters are supposed to be part of the kernel API, experimental
> parameters are often removed.  In addition, downgrading a kernel might cause
> previously-working modules to fail to load.
> 
> On balance, it's probably better to warn, and load the module anyway.

I agree with this.

> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
[...]

This should also go to stable, so the downgrading issue doesn't continue
to bite people.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

