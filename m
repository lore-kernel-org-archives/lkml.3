Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab3AOQss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 11:48:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:60837 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3AOQsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 11:48:47 -0500
Date: Tue, 15 Jan 2013 17:48:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        Matt Fleming <matt.fleming@intel.com>,
        Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>
Subject: Re: [PATCH v7u1 22/31] x86, boot: add fields to support load bzImage
 and ramdisk above 4G
Message-ID: <20130115164843.GB8101@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
	Matt Fleming <matt.fleming@intel.com>,
	Gokul Caushik <caushik1@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>
References: <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
 <50F4452D.2060000@zytor.com>
 <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
 <50F455A3.4070706@zytor.com>
 <CAE9FiQUtbpo0njyPjPED=esKKnSdFs9ry4pFjG1y0LvHxkqV4w@mail.gmail.com>
 <50F46304.3010108@zytor.com>
 <CAE9FiQU_8ngBbXbwrqC1SaR3fScoDNvO_nKOhDYBV_bjOzjwJg@mail.gmail.com>
 <CAE9FiQWxWdeGB-DZp7W2rmukG-KPahF8SQbBcHUWbbUAJA2MhA@mail.gmail.com>
 <20130115155053.GA8101@liondog.tnic>
 <CAE9FiQUyinyu_DxLF_kXO82cMnRmt0fmbkh11vEw2Wr0SAWw_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQUyinyu_DxLF_kXO82cMnRmt0fmbkh11vEw2Wr0SAWw_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 15, 2013 at 08:03:49AM -0800, Yinghai Lu wrote:
> Come on, are you serious? almost none?

Of course I'm serious - the fact that I'm diddling with your patchset
for weeks now should tell you I'm f*cking serious about this.

> I took the comments about sentinel.
> but did not take your comments about change kernel_ident_mapping_init.

Because... ? I saw that you didn't take it but why, you didn't even say
why you didn't take it. And I asked you at the beginning: should we
review this patchset or do you simply ignore comments.

Let's see:

* [PATCH 06/31] x86, 64bit, realmode: use init_level4_pgt to set trapmoline_pgt directly
	- typo still there

* [PATCH 08/31] x86, 64bit: early #PF handler set page table
	- almost no changes, SOB chain still wrong

* [PATCH 12/31] x86: add get_ramdisk_image/size()
	- no change

* [PATCH 13/31] x86, boot: add get_cmd_line_ptr()
	- no change

* [PATCH 14/31] x86, boot: move checking of cmd_line_ptr out of common path
	- no change

* [PATCH 20/31] x86, kexec: replace ident_mapping_init and init_level4_page
	- no change

* [PATCH 21/31] x86, kexec: only set ident mapping for ram.
	- almost

* [PATCH 22/31] x86, boot: add fields to support load bzImage and ramdisk above 4G
	- except sentinel, almost no change

* [PATCH 23/31] x86, boot: update comments about entries for 64bit image
	- almost no change

How's that for "almost none"?!

Oh, and also, some of the suggestions you've taken but then changed
again making them wrong. Here's an example:

Your initial change had:

> +The memory for struct boot_params should be allocated under or above
> +4G and initialized to all zero.

I suggested:

"Memory for struct boot_params may be allocated anywhere (even above
4G). This memory must be zeroed out."

You changed it to:

"The memory for struct boot_params could be allocated anywhere (even
above 4G) and initialized to all zero."

which still reads funny and has a couple of issues.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
