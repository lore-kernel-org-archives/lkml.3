Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbaE0WYJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:24:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40453 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbaE0WYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:24:08 -0400
Date: Wed, 28 May 2014 00:24:04 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] x86, MCE: Flesh out when to panic comment
Message-ID: <20140527222404.GE4366@pd.tnic>
References: <537D1E8B.1010505@zytor.com>
 <CALCETrVP3WtaQ72RgaPUuF2tAZRmJUtEyzyGMKWytv422_thmw@mail.gmail.com>
 <20140521215411.GI25130@pd.tnic>
 <537D21F2.8030702@zytor.com>
 <20140521221121.GL25130@pd.tnic>
 <537D2522.80702@zytor.com>
 <20140526101859.GD25732@pd.tnic>
 <alpine.LNX.2.00.1405261250230.12047@pobox.suse.cz>
 <20140526110634.GG25732@pd.tnic>
 <3908561D78D1C84285E8C5FCA982C28F3281EEA5@ORSMSX114.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3281EEA5@ORSMSX114.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 09:53:56PM +0000, Luck, Tony wrote:
> It is far from obvious that mce_severity() will always say that an
> error detected inside the kernel will be fatal.

Oh yeah, it needs a good cleansing rewrite, that's for sure.

And this tolerant check looks fishy to me:

                if (s->sev >= MCE_UC_SEVERITY && ctx == IN_KERNEL) {
                        if (panic_on_oops || tolerant < 1)
                                return MCE_PANIC_SEVERITY;
                }

since we set it to 1 by default. But I'll look again on a clear head
tomorrow - it is too late here.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
