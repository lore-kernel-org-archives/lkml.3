Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3BCXqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:46:49 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753961Ab3BCXqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:46:45 -0500
Message-ID: <510EF65D.4020602@zytor.com>
Date: Sun, 03 Feb 2013 15:44:29 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 4/4] x86, 32-bit: Drop new_cpu_data
References: <1359908079-10469-1-git-send-email-bp@alien8.de> <1359908079-10469-5-git-send-email-bp@alien8.de>
In-Reply-To: <1359908079-10469-5-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 08:14 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> We copy it to boot_cpu_data anyway so use boot_cpu_data from the get-go.
>

Hmm... this is the only part of this patchset I feel skeptical towards. 
  Overall, a lot of the early SMP code went way out of its way to have 
zero impact on the !CONFIG_SMP case, but that was a long time ago. 
Nowadays what we really should have is cpu_data being a percpu variable 
separate from boot_cpu_data (which is really "all_cpu_data") even on UP.

Another cleanup desperately needed in this area is a bitvector for bugs 
in addition to features.  In fact, I kind of suspect we should make it 
the *same* bitvector (different words) so we cpu_has(X) works on both 
without confusion (just put the BUGS at the end; it means that if we add 
feature words the bug numbers will shift but that is okay.)

I actually mean to do this when I did the CPU feature vector stuff over 
10 years ago, but never got around to it... and it still has never 
gotten done.

The difference between bugs and features, of course, is that the former 
should be combined across CPUs with an OR whereas the latter get 
combined with an AND.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

