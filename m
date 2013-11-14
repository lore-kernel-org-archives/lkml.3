Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab3KNIYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 03:24:21 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43126 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3KNIYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 03:24:18 -0500
MIME-Version: 1.0
In-Reply-To: <20131113235708.GC25344@anatevka.fc.hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
	<d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
	<20131113224503.GB25344@anatevka.fc.hp.com>
	<52840206.5020006@zytor.com>
	<20131113235708.GC25344@anatevka.fc.hp.com>
Date: Thu, 14 Nov 2013 10:24:17 +0200
X-Google-Sender-Auth: Q4TJkbbMjR4eLqvjLax4pVikm9w
Message-ID: <CAOJsxLFkHQ6_f+=CMwfNLykh59TZH5VrWeVEDPCWPF1wiw7tjQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] Early use of boot service memory
From: Pekka Enberg <penberg@kernel.org>
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
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

Hi Jerry,

On Thu, Nov 14, 2013 at 1:57 AM,  <jerry.hoemann@hp.com> wrote:
> I will still point out that as currently used, efi_reserve_boot_services
> is wrong.  A work around for firmware bugs on one platform shouldn't be
> breaking platforms that don't have that bug.  Its just much less likely
> to cause problems with higher crash kernel allocation.

Wrong in what way exactly?

We need efi_reserve_boot_services on _some_ platforms and it's only practical
to do it on all platforms to be able to boot a generic kernel.  Likewise, it
would be more practical to fix crashkernel on all platforms instead of adding a
new code path in the kernel that won't receive as much testing coverage (we
need to reserve boot services by default).

And frankly, I don't understand why 'violating the UEFI specification' is even
brought up.  It's shipped firmware that matters here no matter how broken it
is.  As long as there's a reasonable solution for crashkernel that works on all
platforms, we should go for it instead of special-casing for 'proper firmware'
because it makes testing the kernel more difficult.

                        Pekka
