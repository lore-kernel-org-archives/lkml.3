Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3ANSE1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 13:04:27 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51444 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756687Ab3ANSE0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 13:04:26 -0500
Date: Mon, 14 Jan 2013 19:04:23 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 24/31] x86, boot: Not need to check setup_header
 version for setup_data
Message-ID: <20130114180423.GA6213@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-25-git-send-email-yinghai@kernel.org>
 <20130114112619.GG1228@liondog.tnic>
 <50F44260.5030305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50F44260.5030305@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 09:37:36AM -0800, H. Peter Anvin wrote:
> No, this is a case of cargo-cult programming. I asked Yinghai to
> remove it.
>
> It is cargo-cult programming because the value of boot_params.hdr
> comes from the kernel itself, so all you're doing is telling you the
> boot protocol version associated with the kernel itself, which we
> already know.

LOOL. Great.

> If we find a bootloader that does that incorrectly (e.g. if kexec
> were to blindly copy struct boot_params from the older kernel...
> which ironically would be better than the current situation) then
> the right thing to do would be to have a central place which scrub
> out the fields and just force them to zero rather than putting a
> bunch of tests all over the place.

Ok, I didn't realize that.

And besides, nothing stops a silly boot loader from adjusting
boot_params.hdr.version so that the check - or any check for that matter
- passes, AFAICT.

See, this is exactly the reason why I'm trying to explain to Yinghai
why it is a Good Thing to document stuff like that at least in commit
messages.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
