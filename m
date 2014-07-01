Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048AbaGAWln (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 18:41:43 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:59646 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaGAWll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 18:41:41 -0400
Message-ID: <53B33920.4040800@redhat.com>
Date: Wed, 02 Jul 2014 00:41:36 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gleb Natapov <gleb@kernel.org>, KVM list <kvm@vger.kernel.org>
Subject: Re: [GIT PULL] KVM changes for 3.16-rc4
References: <1404211489-9848-1-git-send-email-pbonzini@redhat.com> <CA+55aFyLk1AWxd9r2zfrKtpawPhw53k_rBdj8kq159i=hf6xsA@mail.gmail.com>
In-Reply-To: <CA+55aFyLk1AWxd9r2zfrKtpawPhw53k_rBdj8kq159i=hf6xsA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 01/07/2014 19:47, Linus Torvalds ha scritto:
> Merges need explanations too. Tell what the branch you are merging
> does, and why you are doing the merge. Yeah, in this case the "branch"
> contains a single commit, but that *still* doesn't excuse not telling
> what the merge is, and why it exists at all.
>
> Seriously. Do "git log --merges" on current git, and look at the
> discrepancy between merge commit messages. That commit 9a630d15f16d is
> pure garbage.
>
> It's not the only crappy one, but it really does stand out. There are
> other one-liners in there, but even then they tend to have at least
> *some* semblance of actual information in them, ie
>
>     Merge branch 'for-v3.16/ti-clk-drv' of
> github.com:t-kristo/linux-pm into clk-next
>
> at least shows that there's a topic branch with a reasonable name, and
> where it comes from. I'd really prefer it to talk about what it merges
> and why, but it's still *much* better than your completely
> information-free merge message.

You're definitely right about the poor commit message.

I made this a merge because I really wanted this commit in the 3.17 
development branch too.  So I applied the patch on top of -rc1 and 
merged it into both branches (kvm-master for 3.16 and kvm-next for 
3.17).  For some reason, I did see a need to justify the merge commit in 
kvm-next:

     commit dc720f95939280f9e69cafe7389be6d0fa6f22dd
     Merge: 27e6fb5dae28 33b458d276bb
     Author: Paolo Bonzini <pbonzini@redhat.com>
     Date:   Mon Jun 30 16:51:07 2014 +0200

         Merge commit '33b458d276bb' into kvm-next

         Fix bad x86 regression introduced during merge window.

Probably still not verbose enough, but a little better.

Am I just over-engineering it and I should have simply cherry-picked it? 
  In this particular case the change is not likely to get other changes 
(and thus conflicts) in kvm-next, but in general it could.

Thanks,

Paolo
