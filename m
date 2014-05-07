Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaEGRug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:50:36 -0400
Received: from mail.codeweavers.com ([216.251.189.131]:38210 "EHLO
	mail.codeweavers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaEGRub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:50:31 -0400
From: Alexandre Julliard <julliard@winehq.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Sven Joachim <svenjoac@gmx.de>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>
	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>
	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>
	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>
	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>
	<87k3aspd1h.fsf@wine.dyndns.org> <87zjiuymiu.fsf@turtle.gmx.de>
	<CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
	<536A68B1.6070500@zytor.com>
Date: Wed, 07 May 2014 19:50:18 +0200
In-Reply-To: <536A68B1.6070500@zytor.com> (H. Peter Anvin's message of "Wed,
	07 May 2014 10:09:05 -0700")
Message-ID: <87eh05fpgl.fsf@wine.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -2.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> On 05/07/2014 09:57 AM, Linus Torvalds wrote:
>> 
>> Afaik, 16-bit programs under wine already need
>> 
>>   echo 0 > /proc/sys/vm/mmap_min_addr
>> 
>> because they want to map things at address 0, so this isn't a new concept.
>> 
>
> I think that applies to DOSEMU, but not to Wine.

Yes, there are a few exceptions, but most Win16 apps run fine without
mapping address 0.

> I'm somewhat curious if this program you have is actually a 32-bit
> program or if it is really a 16-bit program wrapped in a 32-bit
> installer of some kind.  Hard to know without seeing the program in
> question.

It could be a mix of both, there are various thunking mechanisms that
allow 32-bit binaries to use 16-bit components. This was pretty common
in the Win95 days.

-- 
Alexandre Julliard
julliard@winehq.org
