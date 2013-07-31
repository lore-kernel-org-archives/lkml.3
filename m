Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760680Ab3GaSAh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:00:37 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:52607 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab3GaSAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:00:34 -0400
MIME-Version: 1.0
In-Reply-To: <51F8DCFC.9050205@linux.vnet.ibm.com>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
 <20130724171347.GB29756@naverao1-tp.watson.ibm.com> <1374686598.18818.18.camel@joe-AO722>
 <51F10AA8.2050901@linux.vnet.ibm.com> <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com>
 <51F8DCFC.9050205@linux.vnet.ibm.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 31 Jul 2013 12:00:13 -0600
Message-ID: <CAErSpo6hcjL_A9Vr1R0GqobUysdskd8B1S_9r7-zBSUvELFPXw@mail.gmail.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: Joe Perches <joe@perches.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 3:46 AM, Naveen N. Rao
<naveen.n.rao@linux.vnet.ibm.com> wrote:

> My key question was about why we are using a field width of 10 implying a
> 32-bit value, rather than a field width of 18 as suggested by the data type?
> This shouldn't truncate the value, but if we are specifying the field width
> for alignment, seems to me it is better to match the data type.

%pR uses a field width of 10 (two for "0x", eight for the value)
simply because the majority of resource values fit in 32 bits.  Larger
values extend the width, so it's not a question of truncating any
data.  But it's no fun to read memory addresses when most of them have
eight extra leading zeros (the high 32-bits of a 64-bit value).  I
think the same applies here; most ACPI table addresses still fit in 32
bits.

We *do* use a field width of 18 for the e820 table, even though many
of those regions fit in 32 bits.  But that's sort of an exception
because it's a table where addresses above 4GB are pretty common.

But at the end of the day, I guess I'm just stating my personal
preferences and yours might be different.

Bjorn
