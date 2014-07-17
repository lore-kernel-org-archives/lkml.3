Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaGQSm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:42:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45643 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751084AbaGQSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:42:25 -0400
Message-Id: <1405622543.23772.142820021.13876840@webmail.messagingengine.com>
X-Sasl-Enc: EzdgHemrso8GHZxt6dfx8Q3BcjFCBwVG7t5xAxRAh7Gq 1405622543
From: Hannes Frederic Sowa <hannes@stressinduktion.org>
To: Andy Lutomirski <luto@amacapital.net>, "Theodore Ts'o" <tytso@mit.edu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>, linux-kernel@vger.kernel.org,
        Kees Cook <keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-741a34df
In-Reply-To: <CALCETrULQcPNOPvt1iX5oZdfY_a64NA5tOcDe5KWsCwBvoKrGA@mail.gmail.com>
References: <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
 <53C6F5A9.80400@zytor.com>
 <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
 <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
 <53C703ED.2010605@zytor.com>
 <CALCETrVSG_Lp=OSw-U+QK+_VsEhKBS=rBQ3ojTrnO9kAKR+Qag@mail.gmail.com>
 <53C75733.8060507@zytor.com> <20140717103324.GJ1491@thunk.org>
 <53C7FC32.7030704@zytor.com>
 <CALCETrVgCw2_8x1+NrP_xO4ZtnFm_dTTUBtZd-tgfdWgfeu2FQ@mail.gmail.com>
 <20140717173230.GP1491@thunk.org>
 <CALCETrULQcPNOPvt1iX5oZdfY_a64NA5tOcDe5KWsCwBvoKrGA@mail.gmail.com>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
Date: Thu, 17 Jul 2014 20:42:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, Jul 17, 2014, at 19:34, Andy Lutomirski wrote:
> On Thu, Jul 17, 2014 at 10:32 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> > On Thu, Jul 17, 2014 at 10:12:27AM -0700, Andy Lutomirski wrote:
> >>
> >> Unless I'm reading the code wrong, the prandom_reseed_late call can
> >> happen after userspace is running.
> >
> > But there is also the prandom_reseed() call, which happens early.
> >
> 
> Right -- I missed that.

prandom_init is a core_initcall, prandom_reseed is a late_initcall.
During initialization of the network stack we have calls to prandom_u32
before the late_initcall happens. That said, I think it is not that
important to seed prandom with rdseed/rdrand as security relevant
entropy extraction should always use get_random_bytes(), but we should
do it nonetheless.

Bye,
Hannes
