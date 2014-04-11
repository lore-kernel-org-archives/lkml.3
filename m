Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233AbaDKSpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 14:45:19 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:38235 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbaDKSpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 14:45:14 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
Date: Fri, 11 Apr 2014 14:45:12 -0400
Message-ID: <CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on
 64-bit kernels
From: Brian Gerst <brgerst@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 11, 2014 at 2:41 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Apr 11, 2014 at 11:27 AM, Brian Gerst <brgerst@gmail.com> wrote:
>> Is this bug really still present in modern CPUs?  This change breaks
>> running 16-bit apps in Wine.  I have a few really old games I like to
>> play on occasion, and I don't have a copy of Win 3.11 to put in a VM.
>
> Ok, so you actually do this on x86-64, and it currently works? For
> some reason I thought that 16-bit windows apps already didn't work.
>
> Because if we have working users of this, then I don't think we can do
> the "we don't support 16-bit segments", or at least we need to make it
> runtime configurable.
>
>              Linus

I haven't tested it recently but I do know it has worked on 64-bit
kernels.  There is no reason for it not to, the only thing not
supported in long mode is vm86.  16-bit protected mode is unchanged.
