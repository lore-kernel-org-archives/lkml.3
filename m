Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaGQMeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 08:34:12 -0400
Received: from imap.thunk.org ([74.207.234.97]:40737 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756556AbaGQMeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 08:34:09 -0400
Date: Thu, 17 Jul 2014 06:33:24 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
        Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH v3 2/5] random,x86: Add arch_get_slow_rng_u64
Message-ID: <20140717103324.GJ1491@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@amacapital.net>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>, X86 ML <x86@kernel.org>,
	Bandan Das <bsd@redhat.com>, Gleb Natapov <gleb@kernel.org>,
	kvm list <kvm@vger.kernel.org>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Daniel Borkmann <dborkman@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>
References: <cover.1405546879.git.luto@amacapital.net>
 <5778e65d5ca52bebbaa023e177d863e44f098e96.1405546879.git.luto@amacapital.net>
 <53C6F5A9.80400@zytor.com>
 <CALCETrVwT1g-S1hLyyB_uAVwffYCnFacTfUhJeD8Bb5j3X0mkg@mail.gmail.com>
 <CALCETrVCrJEwYokasRoqQTKJWKtzq9XUMNqHoT4-ZjgyZ-mBow@mail.gmail.com>
 <53C703ED.2010605@zytor.com>
 <CALCETrVSG_Lp=OSw-U+QK+_VsEhKBS=rBQ3ojTrnO9kAKR+Qag@mail.gmail.com>
 <53C75733.8060507@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C75733.8060507@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 09:55:15PM -0700, H. Peter Anvin wrote:
> On 07/16/2014 05:03 PM, Andy Lutomirski wrote:
> >>
> > I meant that prandom isn't using rdrand for early seeding.
> > 
> 
> We should probably fix that.

It wouldn't hurt to explicitly use arch_get_random_long() in prandom,
but it does use get_random_bytes() in early seed, and for CPU's with
RDRAND present, we do use it in init_std_data() in
drivers/char/random.c, so prandom is already getting initialized via
an RNG (which is effectively a DRBG even if it doesn't pass all of
NIST's rules) which is derived from RDRAND.

Cheers,

					- Ted

