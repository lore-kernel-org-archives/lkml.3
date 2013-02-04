Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3BDDVw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 22:21:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54612 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759Ab3BDDVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 22:21:50 -0500
Message-ID: <510F2933.6010807@zytor.com>
Date: Sun, 03 Feb 2013 19:21:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>, Dave Jones <davej@redhat.com>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: avr32: add dummy syscalls
References: <1359291015-4544-1-git-send-email-matthias.bgg@gmail.com> <20130127195714.GA11224@samfundet.no> <20130127203009.GG4503@ZenIV.linux.org.uk> <20130127203954.GA22063@samfundet.no> <20130204001055.GV4503@ZenIV.linux.org.uk> <20130204003047.GW4503@ZenIV.linux.org.uk> <20130204013111.GX4503@ZenIV.linux.org.uk>
In-Reply-To: <20130204013111.GX4503@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 05:31 PM, Al Viro wrote:
>
> Unless I'm misreading ocavr32.pdf, that should be (R12, R10:R11, R9, R8) and
> (R12, R10:R11, R9:R8, stack) resp., so fadvise64 doesn't need a wrapper, but
> fadvise64_64 does.  And something like (s32, s32, s64, s64) would turn into
> (R12, R11, R9:R8, stack, stack); AFAICS, we don't have anything that ugly...
>
> Automating *that* is going to be interesting...  I've not given up, but it's
> not going to be fun ;-/
>

Feel free to steal machinery from klibc... it has scripts to 
autogenerate stubs for arbitrary ABIs.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

