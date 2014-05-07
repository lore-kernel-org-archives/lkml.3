Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaEGRJb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 13:09:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51318 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbaEGRJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 13:09:29 -0400
Message-ID: <536A68B1.6070500@zytor.com>
Date: Wed, 07 May 2014 10:09:05 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Sven Joachim <svenjoac@gmx.de>
CC: Alexandre Julliard <julliard@winehq.org>, Brian Gerst <brgerst@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, stable <stable@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [tip:x86/urgent] x86-64, modify_ldt: Ban 16-bit segments on 64-bit
 kernels
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org>	<CAMzpN2jx4H4p8fQr-WHxVyCHhWi0iO3WZZKyxYD7Dfa7pWkEgg@mail.gmail.com>	<CA+55aFwzvSiAGYfFb2R3JeVvh8_PQuOKJDrYP5C_3VQz2zhnBw@mail.gmail.com>	<CAMzpN2jj3dwQG7qC__8zLPhkg_ER6n4CcNxa5eg7okRN+k_VUA@mail.gmail.com>	<CA+55aFxr_dz3vhko1FPXhZd0ZNeGveX0oSLqUo_wyiVbxatLQw@mail.gmail.com>	<87k3aspd1h.fsf@wine.dyndns.org>	<87zjiuymiu.fsf@turtle.gmx.de> <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
In-Reply-To: <CA+55aFw9BPoD10U1LfHbOMpHWZkvJTkMcfCs9s3urPr1YyWBxw@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/2014 09:57 AM, Linus Torvalds wrote:
> 
> Afaik, 16-bit programs under wine already need
> 
>   echo 0 > /proc/sys/vm/mmap_min_addr
> 
> because they want to map things at address 0, so this isn't a new concept.
> 

I think that applies to DOSEMU, but not to Wine.

Sven: if you have the ability to build your own kernel, could you also
try the "x86/espfix" branch of the git tree:

https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/

(clone URLs:)
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
https://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git

... to make sure the proper solution works for you?

I'm somewhat curious if this program you have is actually a 32-bit
program or if it is really a 16-bit program wrapped in a 32-bit
installer of some kind.  Hard to know without seeing the program in
question.

	-hpa

