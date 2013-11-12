Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3KLSs7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 13:48:59 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:42049 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755065Ab3KLSsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 13:48:53 -0500
MIME-Version: 1.0
In-Reply-To: <20131112175500.GA22363@anatevka.fc.hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
	<CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
	<20131112175500.GA22363@anatevka.fc.hp.com>
Date: Tue, 12 Nov 2013 20:48:51 +0200
X-Google-Sender-Auth: 3LxxgRY_HzI_PDZH5Y9rgSvhM9s
Message-ID: <CAOJsxLEU1SPd=1C8QPgrZGWeOuyOVkozuMR014xBpJTxyFviKA@mail.gmail.com>
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

Hi Jerry,

On Tue, Nov 12, 2013 at 7:55 PM,  <jerry.hoemann@hp.com> wrote:
> My change does not address platforms that have misbehaving firmware.
> It just allows platforms that don't have this issue to avoid issues
> that the call to efi_reserve_boot_services presents.

The problem I have with your patch is that it (1) relies on users to
pass a kernel option and (2) leaves machines with "faulty firmware" out
in the cold.  So I'm wondering if we can fix reserve_crashkernel() to
deal with reality that there indeed are broken firmware out there?

If someone is able to come up with a convincing argument why crashkernel
cannot be fixed on such machines, we'd need to start whitelisting known
good firmwares, no?

                           Pekka
