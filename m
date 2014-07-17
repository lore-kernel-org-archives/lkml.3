Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaGQRpp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 13:45:45 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:50394 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930AbaGQRpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 13:45:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAKB9nXs=htVXQciEfXQ4tMnLJT8RemHoVs+dVGPWXN+rGbdk6g@mail.gmail.com>
References: <cover.1405546879.git.luto@amacapital.net> <3e019617640d1b07d0ab1c9a91455957c201d4cd.1405546879.git.luto@amacapital.net>
 <CAKB9nXs=htVXQciEfXQ4tMnLJT8RemHoVs+dVGPWXN+rGbdk6g@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 17 Jul 2014 10:45:22 -0700
Message-ID: <CALCETrW0gbWMujW0+cty7nzaNxvAeUpsFDFrhg1bFxBL_wrDcw@mail.gmail.com>
Subject: Re: [PATCH v3 1/5] x86,kvm: Add MSR_KVM_GET_RNG_SEED and a matching
 feature bit
To: Andrew Honig <ahonig@google.com>
Cc: kvm <kvm@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, X86 ML <x86@kernel.org>,
        Daniel Borkmann <dborkman@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
        Bandan Das <bsd@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 10:43 AM, Andrew Honig <ahonig@google.com> wrote:
>> +       case MSR_KVM_GET_RNG_SEED:
>> +               get_random_bytes(&data, sizeof(data));
>> +               break;
>
> Should this be rate limited in the interest of conserving randomness?
> If there ever is an attack on the prng, this would create very
> favorable conditions for an attacker to exploit it.

IMO if the nonblocking pool has a weakness that requires us to
conserve its output, then this is the least of our worries.

--Andy
