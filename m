Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757471Ab3ANRiV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:38:21 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55246 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757370Ab3ANRiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:38:19 -0500
Message-ID: <50F44260.5030305@zytor.com>
Date: Mon, 14 Jan 2013 09:37:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 24/31] x86, boot: Not need to check setup_header
 version for setup_data
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org> <1357260531-11115-25-git-send-email-yinghai@kernel.org> <20130114112619.GG1228@liondog.tnic>
In-Reply-To: <20130114112619.GG1228@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 03:26 AM, Borislav Petkov wrote:
> On Thu, Jan 03, 2013 at 04:48:44PM -0800, Yinghai Lu wrote:
>> That is for bootloader.
>>
>> setup_data is in setup_header, and all bootloader is copying that
>> for bzImage. So for old bootloader should keep that as 0.
>
> Are you sure all old bootloaders have kept setup_data as 0 so that you
> can drop the check.
>
> And besides, the check doesn't hurt but prevents insane old boot loaders
> from handing in crap into the kernel so I'd leave it in.
>

No, this is a case of cargo-cult programming.  I asked Yinghai to remove it.

It is cargo-cult programming because the value of boot_params.hdr comes 
from the kernel itself, so all you're doing is telling you the boot 
protocol version associated with the kernel itself, which we already know.

If we find a bootloader that does that incorrectly (e.g. if kexec were 
to blindly copy struct boot_params from the older kernel... which 
ironically would be better than the current situation) then the right 
thing to do would be to have a central place which scrub out the fields 
and just force them to zero rather than putting a bunch of tests all 
over the place.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

