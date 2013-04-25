Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab3DYWUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 18:20:20 -0400
Received: from mail-ve0-f181.google.com ([209.85.128.181]:38405 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933105Ab3DYWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 18:20:16 -0400
MIME-Version: 1.0
In-Reply-To: <201304252144.r3PLihDe025383@terminus.zytor.com>
References: <201304252144.r3PLihDe025383@terminus.zytor.com>
Date: Thu, 25 Apr 2013 15:20:15 -0700
X-Google-Sender-Auth: JY73dkvGm4TLcjlQiBpjG9uSJXg
Message-ID: <CA+55aFxxWXrQU4oZUbHOBBkvtF=pSxMvyF6sYU9xpSDarWV-=Q@mail.gmail.com>
Subject: Re: [GIT PULL] x86 fixes for 3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Josh Boyer <jwboyer@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Paul Bolle <pebolle@tiscali.nl>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 2:44 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
>
> -       if (!sys_table->runtime->query_variable_info)
> +       if (sys_table->runtime->hdr.revision < EFI_2_00_SYSTEM_TABLE_REVISION)
>                 return EFI_UNSUPPORTED;

Is a EFI 2.00 system table *guaranteed* to have that
"query_variable_info" function? The above adds the version check, but
removes the check for a NULL pointer.

And why the hell don't we have a real structure that has been filled
out properly, and instead apparently just do this "point to random
memory that doesn't necessarily have the full structure?

             Linus
