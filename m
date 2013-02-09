Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034Ab3BIKlw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 05:41:52 -0500
Received: from mail.skyhub.de ([78.46.96.112]:50788 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729Ab3BIKlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 05:41:50 -0500
Date: Sat, 9 Feb 2013 11:41:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH] x86: Add support for 64bit get_user() on x86-32
Message-ID: <20130209104142.GA17907@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
	linux-kernel@vger.kernel.org, x86@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jamie Lokier <jamie@shareable.org>,
	Russell King <rmk+kernel@arm.linux.org.uk>
References: <1355312043-11467-1-git-send-email-ville.syrjala@linux.intel.com>
 <20130207165347.GF9135@intel.com>
 <5113EB64.2080002@zytor.com>
 <20130208162427.GG9135@intel.com>
 <5115361D.8060501@zytor.com>
 <20130208182308.GI9135@intel.com>
 <ea6b316f-c142-4fc0-9f74-281380ab1dac@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ea6b316f-c142-4fc0-9f74-281380ab1dac@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 11:08:52AM -0800, H. Peter Anvin wrote:
> Yes, or anything else getting a pointer in memory from user space.

Here are some more from a 32-bit build here:

fs/exec.c: In function ‘get_user_arg_ptr’:
fs/exec.c:414:6: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
fs/splice.c: In function ‘vmsplice_to_user’:
fs/splice.c:1556:11: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
ipc/syscall.c: In function ‘sys_ipc’:
ipc/syscall.c:39:7: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
