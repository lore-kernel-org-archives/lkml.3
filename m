Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaHMSW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:22:29 -0400
Received: from imap.thunk.org ([74.207.234.97]:58792 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753531AbaHMSW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:22:27 -0400
Date: Wed, 13 Aug 2014 14:22:19 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get
 some from kvm
Message-ID: <20140813182219.GE6437@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andy Lutomirski <luto@amacapital.net>,
	kvm list <kvm@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
	Daniel Borkmann <dborkman@redhat.com>,
	Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
	Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
	Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
	Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
References: <cover.1406177531.git.luto@amacapital.net>
 <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
 <20140812191723.GI12871@thunk.org>
 <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
 <53EB1859.6030800@zytor.com>
 <20140813143209.GD6437@thunk.org>
 <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com>
 <53EBA435.3020207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EBA435.3020207@zytor.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 10:45:25AM -0700, H. Peter Anvin wrote:
> On 08/13/2014 09:13 AM, Andy Lutomirski wrote:
> > 
> > Sounds good to me.
> > 
> > FWIW, I'd like to see a second use added in random.c: I think that we
> > should do this, or even all of init_std_data, on resume from suspend
> > and especially on resume from hibernate / kexec.
> > 
> 
> Yes, we should.  We also need to make it possible to do this after
> cloning a VM.

Agreed.  Can you send a patch?

I can carry the commits to add arch_random_init() the generic version,
and the patch to call it after suspend/resume.  I'll do this at the
very head of the random tree, and make sure it gets pushed to Linus
early during the next merge window.

Does that sound like a plan?  Or does someone want to suggest
something different?  I'm flexible...

						- Ted
