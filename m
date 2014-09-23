Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbaIWFom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:44:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40629 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaIWFol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:44:41 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20140923053711.GA28704@gmail.com>
References: <20140919104021.GA11552@gmail.com> <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com> <20140923053510.GB27825@gmail.com> <20140923053711.GA28704@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [GIT PULL] x86 fixes
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 22 Sep 2014 22:44:16 -0700
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <32c24277-c815-4ca6-98c5-77bf040c1384@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That would be my guess, too.

On September 22, 2014 10:37:11 PM PDT, Ingo Molnar <mingo@kernel.org> wrote:
>
>* Ingo Molnar <mingo@kernel.org> wrote:
>
>> 
>> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> 
>> > On Fri, Sep 19, 2014 at 3:40 AM, Ingo Molnar <mingo@kernel.org>
>wrote:
>> > >
>> > > Please pull the latest x86-urgent-for-linus git tree from:
>> > 
>> > I only just noticed, but this pull request causes my Sony Vaio 
>> > laptop to immediately reboot at startup.
>> > 
>> > I'm assuming it's one of the efi changes, but I'm bisecting now 
>> > to say exactly where it happens. It will get reverted.
>> 
>> I've Cc:-ed Matt.
>> 
>> My guess would be one of these two EFI commits:
>> 
>>       * Fix early boot regression affecting x86 EFI boot stub when
>loading
>>         initrds above 4GB - Yinghai Lu
>>     
>> 47226ad4f4cf x86/efi: Only load initrd above 4g on second try
>> 
>>       * Relocate GOT entries in the x86 EFI boot stub now that we
>have
>>         symbols with global visibility - Matt Fleming
>> 
>> 9cb0e394234d x86/efi: Fixup GOT in all boot code paths
>> 
>> If it's 9cb0e394234d - then it's perhaps a build quirk, or a bug 
>> in the assembly code. If so then we'd have to revert this, and 
>> reintroduce another regression, caused by EFI commit 
>> f23cf8bd5c1f49 in this merge window. The most recent commit is 
>> easy to revert, the older one not.
>> 
>> If it's 47226ad4f4cf then we'd reintroduce the regression caused 
>> by 4bf7111f501 in the previous merge window. They both revert 
>> cleanly after each other - but it might be safer to just revert 
>> the most recent one.
>>
>> My guess is that your regression is caused by 47226ad4f4cf.
>
>Wrong sha1: my guess is on 9cb0e394234d, the GOT fixup.
>
>Thanks,
>
>	Ingo

-- 
Sent from my mobile phone.  Please pardon brevity and lack of formatting.
