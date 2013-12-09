Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3LIXlk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 18:41:40 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:36131 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab3LIXli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 18:41:38 -0500
MIME-Version: 1.0
In-Reply-To: <20131208150904.GD4338@pd.tnic>
References: <1386476273-2418-1-git-send-email-rui.y.wang@intel.com>
 <20131208144312.GC4338@pd.tnic> <20131208150904.GD4338@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Dec 2013 16:41:18 -0700
Message-ID: <CAErSpo7M=d0qMUCV2CCjkkbMX7h-xQcp0tuST89G_HefTQVoyg@mail.gmail.com>
Subject: Re: [PATCH] aerdrv: Fix severity usage in aer trace event
To: Borislav Petkov <bp@alien8.de>
Cc: Rui Wang <ruiv.wang@gmail.com>, Lance Ortiz <lance.ortiz@hp.com>,
        "lance_ortiz@hotmail.com" <lance_ortiz@hotmail.com>,
        jiang.liu@intel.com, Tony Luck <tony.luck@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <rui.y.wang@intel.com>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Joe]

On Sun, Dec 8, 2013 at 8:09 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Sun, Dec 08, 2013 at 03:43:12PM +0100, Borislav Petkov wrote:
>> On Sun, Dec 08, 2013 at 12:17:53PM +0800, Rui Wang wrote:
>> > There's inconsistency between dmesg and the trace event output.
>> > When dmesg says "severity=Corrected", the trace event says
>> > "severity=Fatal". What happens is that HW_EVENT_ERR_CORRECTED is
>> > defined in edac.h:
>> >
>> > enum hw_event_mc_err_type {
>> >         HW_EVENT_ERR_CORRECTED,
>> >         HW_EVENT_ERR_UNCORRECTED,
>> >         HW_EVENT_ERR_FATAL,
>> >         HW_EVENT_ERR_INFO,
>> > };
>> >
>> > while aer_print_error() uses aer_error_severity_string[] defined as:
>> >
>> > static const char *aer_error_severity_string[] = {
>> >         "Uncorrected (Non-Fatal)",
>> >         "Uncorrected (Fatal)",
>> >         "Corrected"
>> > };
>> >
>> > In this case dmesg is correct because info->severity is assigned in
>> > aer_isr_one_error() using the definitions in include/linux/ras.h:
>> >
>> > Signed-off-by: Rui Wang <rui.y.wang@intel.com>
>>
>> Applied, thanks.
>
> I said "Applied" but this is Bjorn's area: Bjorn, wanna take this one or
> are you fine with it going over the RAS tree?
>
> Btw, I have a 2 trivial cleanups for aerdrv_errprint.c which are
> following...

I think it's worthwhile to keep all three patches together, and I'd be
happy to merge them via PCI.  It looks like Joe had some good
questions, so once you resolve them, I can merge them, or ack them and
you can take them.  I think either way will be fine.

Bjorn
