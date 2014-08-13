Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418AbaHMSdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 14:33:53 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:58475 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbaHMSdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 14:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140813182219.GE6437@thunk.org>
References: <cover.1406177531.git.luto@amacapital.net> <CALCETrXtLf3ZFtyrbwj29C=t3PcTxRT2AJWZCUHdKC3AYyUVAA@mail.gmail.com>
 <20140812191723.GI12871@thunk.org> <CALCETrVmviT=upxHfPfmLy2aUOKdCuCbNg9WZQcx6f=8T8vv=g@mail.gmail.com>
 <53EB1859.6030800@zytor.com> <20140813143209.GD6437@thunk.org>
 <CALCETrUQ8yRmmN1kbdCy99ae2+-Xp4caOBgrXvaQhCCUi=i0zg@mail.gmail.com>
 <53EBA435.3020207@zytor.com> <20140813182219.GE6437@thunk.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 13 Aug 2014 11:33:29 -0700
Message-ID: <CALCETrVTsyq4u+G2Td7Gmi6pa6c1ePgavqN31mjo9_E5=7bGCg@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] random,x86,kvm: Rework arch RNG seeds and get some
 from kvm
To: "Theodore Ts'o" <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>, Andrew Honig <ahonig@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 11:22 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 13, 2014 at 10:45:25AM -0700, H. Peter Anvin wrote:
>> On 08/13/2014 09:13 AM, Andy Lutomirski wrote:
>> >
>> > Sounds good to me.
>> >
>> > FWIW, I'd like to see a second use added in random.c: I think that we
>> > should do this, or even all of init_std_data, on resume from suspend
>> > and especially on resume from hibernate / kexec.
>> >
>>
>> Yes, we should.  We also need to make it possible to do this after
>> cloning a VM.
>
> Agreed.  Can you send a patch?
>
> I can carry the commits to add arch_random_init() the generic version,
> and the patch to call it after suspend/resume.  I'll do this at the
> very head of the random tree, and make sure it gets pushed to Linus
> early during the next merge window.
>
> Does that sound like a plan?  Or does someone want to suggest
> something different?  I'm flexible...

OK.  Here's a proposal.  I'll split the series into two parts.  The
first part will be the arch_random_init generic change and code to
call it after suspend/resume (once I figure out the right callback).
I'll send that to you.

The second part will be the KVM and x86 code, which will look just
like this version (v5) except for the rename.  If needed, hpa and I
can hash the details we need at KS.

As for doing arch_random_init after clone/migration, I think we'll
need another KVM extension for that, since, AFAIK, we don't actually
get notified that we were cloned or migrated.  That will be
nontrivial.  Maybe we can figure that out at KS, too.

--Andy

>
>                                                 - Ted



-- 
Andy Lutomirski
AMA Capital Management, LLC
