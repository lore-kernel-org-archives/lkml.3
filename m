Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3KTVoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 16:44:20 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:62228 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab3KTVoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 16:44:17 -0500
MIME-Version: 1.0
In-Reply-To: <528D1D44.3000600@zytor.com>
References: <1384634221-6006-1-git-send-email-fenghua.yu@intel.com>
	<tip-f4cb1cc18f364d761d5614eb6293cccc6647f259@git.kernel.org>
	<CA+55aFyFz_6oy8-1jb5Jzk+4VC5MLA5d0KbqhZxki0=+DmggBg@mail.gmail.com>
	<528D0D61.1030902@linux.intel.com>
	<CA+55aFz9-bh=L8vf9qd3kx7wMtYqTtqx8YzULABX5reGtPBExw@mail.gmail.com>
	<528D1D44.3000600@zytor.com>
Date: Wed, 20 Nov 2013 13:44:16 -0800
X-Google-Sender-Auth: i025z0ram7a-JPygbwDNbkKmGEE
Message-ID: <CA+55aFyd5C_G=LDs-EbWaDjGXkOZ2AvZtZSr+Jp0fWo5=FgsQQ@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86-64, copy_user: Remove zero byte check before
 copy user buffer.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-tip-commits@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> That being said, "lea (%rdx,%rcx,8),%ecx" (leal, as opposed to leaq) is
> a perfectly legitimate instruction and actually one byte shorter.  The
> big question is if some broken version of gas will choke on it.

At least gcc-4.8.2 generates that instruction (try multiplying an
integer value by 9), so I guess gas will be happy. Except gcc uses
"leal", so to be safe..

              Linus
