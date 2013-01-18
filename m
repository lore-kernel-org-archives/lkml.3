Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659Ab3ARXFA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 18:05:00 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:39058 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3ARXE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 18:04:59 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <5156.1358549663@warthog.procyon.org.uk>
References: <CA+icZUV+ewSfwdGv+XjzVMF+V5d1t3r6MWGvoBgf08CN=KpBgQ@mail.gmail.com>
	<CA+icZUXNbhX4a0ZG039O5dWiZHpuVM-mwOSD_4g+f==xWD=4Zw@mail.gmail.com>
	<5156.1358549663@warthog.procyon.org.uk>
Date: Sat, 19 Jan 2013 00:04:58 +0100
Message-ID: <CA+icZUW_-3Bg9PSBoht0mqikVb1wn+21BNFy8Fsm5thZfNunXw@mail.gmail.com>
Subject: Re: linux-next: Tree for Jan 18 [MODSIGN: KEYS:]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: David Howells <dhowells@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 11:54 PM, David Howells <dhowells@redhat.com> wrote:
> Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
>> Culprit seems to be...
>>
>> commit d6941c0c6bd42c725e45240a86c4add92e9bfb3e
>> "KEYS: Separate the kernel signature checking keyring from module signing"
>
> Try updating.  I pushed a new version out today.  This is now at commit ID
> c82af351e270e0d95059d09a1975b61494fbbcd7.
>

Thanks for the information!

OK, I see... s/select/depends on...

 +config SYSTEM_TRUSTED_KEYRING
 +      bool "Provide system-wide ring of trusted keys"
-+      select KEYS
++      depends on KEYS

That should fix it :-).
I set SYSTEM_TRUSTED_KEYRING=y in kernel-config.

BAD: http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=patch;h=d6941c0c6bd42c725e45240a86c4add92e9bfb3e

GOOD: http://git.kernel.org/?p=linux/kernel/git/dhowells/linux-modsign.git;a=patch;h=c82af351e270e0d95059d09a1975b61494fbbcd7

- Sedat -

> David
