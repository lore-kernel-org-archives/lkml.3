Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab3HSUro (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:47:44 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:35205 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab3HSUrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:47:42 -0400
MIME-Version: 1.0
In-Reply-To: <e7fc4e2f-4cda-4eef-8d37-bb87773f58e8@email.android.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
	<e7fc4e2f-4cda-4eef-8d37-bb87773f58e8@email.android.com>
Date: Mon, 19 Aug 2013 13:47:41 -0700
X-Google-Sender-Auth: OU-u4BCI-WB4MzVEm3S9hj5bE2g
Message-ID: <CAE9FiQWRp+AMeTnC3MPSWi4as6qaoFiZEsAfjr3+75YT9XMPcQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] EFI boot stub memory map fix
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linn Crosetto <linn@hp.com>, Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        linux-efi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 1:06 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I would strongly disagree that option 2 is the cleaner solution.

Agreed.

>
> Linn Crosetto <linn@hp.com> wrote:
>>I realize the EFI stub for ARM patches are in flight,
>>
>>https://lkml.org/lkml/2013/8/9/554
>>
>>and overlap with some of the files but I wanted to send these out for
>>comment.
>>
>>This series fixes a problem with EFI memory maps larger than 128
>>entries when
>>booting using the EFI boot stub, which results in overflowing the
>>e820_map in
>>boot_params and an eventual halt when checking the map size in
>>sanitize_e820_map().
>>
>>The fix implemented is to add the EFI memory map from setup_arch() via
>>a
>>memory_setup hook.
>>
>>Two options were considered:
>>
>> 1. Use the SETUP_E820_EXT setup_data type to add the extra entries.
>>
>>2. Create a memory_setup function to be enabled when the EFI memory map
>>is
>>    needed.
>>
>>Option 2 appeared to be the cleaner solution, reducing duplication with
>>existing code, given a reasonable mechanism for determining when to
>>replace the default memory_setup function.

If boot_loader could create setup_data with SETUP_E820_EXT,
efi_stub should go that path too.
We should not add another path.

Thanks

Yinghai
