Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab3ANU03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 15:26:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40196 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757559Ab3ANU02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 15:26:28 -0500
Date: Mon, 14 Jan 2013 21:26:23 +0100
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
Message-ID: <20130114202623.GD2015@liondog.tnic>
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
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-23-git-send-email-yinghai@kernel.org>
 <20130113214132.GB17200@liondog.tnic>
 <CAE9FiQVQRAOtw7kiPJO3xszJx9uPFjgK82PjbvTyqzJgujdicw@mail.gmail.com>
 <50F4452D.2060000@zytor.com>
 <CAE9FiQXkgoLKp3ZnOcM9gLDJNGNxUE8WSRXiQy1G_v5Os5_v2A@mail.gmail.com>
 <20130114200505.GC2015@liondog.tnic>
 <CAE9FiQWXxmOnoc1wJzHUYCyO8hHvLOkNpGMwM8vVubjMAGJ5dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQWXxmOnoc1wJzHUYCyO8hHvLOkNpGMwM8vVubjMAGJ5dA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14, 2013 at 12:14:18PM -0800, Yinghai Lu wrote:
> no, no, no.
> 
> bootloader does not need to know sentinel, and they only need to do:
>     clearing boot_param buffer and copying setup_header only
> 
> even new bootloader is not supposed to know sentinel ...

Ah, ok. I thought something was fishy because if bootloaders would know
about it, they'd copy setup_header and zero out the sentinel only, to
force the kernel to use crappy ext_* etc. values.

How about this:

"The sentinel variable is set by the linker script to 0xff. It is
supposed to be used for catching bootloaders which just copy the
setup_header portion and don't clear the whole boot_params buffer as
they are supposed to. Such bootloaders will leave the sentinel to its
initial value of 0xff and in this case, the kernel will assume that some
fields in boot_params have invalid values and zero them out."

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
