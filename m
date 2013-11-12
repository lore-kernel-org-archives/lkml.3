Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab3KLKhc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 05:37:32 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:60911 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab3KLKha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 05:37:30 -0500
MIME-Version: 1.0
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Date: Tue, 12 Nov 2013 12:37:29 +0200
X-Google-Sender-Auth: ydlN0RtNGBiMwD8ngUhjZ84LyS0
Message-ID: <CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Pekka Enberg <penberg@kernel.org>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86 maintainers <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," 
	<linux-doc@vger.kernel.org>,
        linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 4:15 AM, Jerry Hoemann <jerry.hoemann@hp.com> wrote:
> Some platform have firmware that violates UEFI spec and access boot service
> code or data segments after the system has called Exit Boot Services.
> The call to efi_reserve_boot_services in setup_arch is a work around to
> avoid using boot service memory until after the kernel has done
> Set Virtual Map.
>
> However, this reservation fragments memory which can cause
> large allocations early in boot (e.g. crash kernel) to fail.

What is the exact problem you're trying to solve here? How will the
problem be fixed for platforms that break the UEFI specification?

                        Pekka
