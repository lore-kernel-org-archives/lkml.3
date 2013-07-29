Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3G2Oun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 10:50:43 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:52358 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab3G2Oul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 10:50:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130729144046.GE6634@pd.tnic>
References: <1374526866-6813-1-git-send-email-bp@alien8.de>
 <20130724171347.GB29756@naverao1-tp.watson.ibm.com> <1374686598.18818.18.camel@joe-AO722>
 <51F10AA8.2050901@linux.vnet.ibm.com> <CAErSpo5vLbsM5BXjrCVy1AKBxRRSH33TthyyK3O35Mghqw81nQ@mail.gmail.com>
 <20130729135812.GD6634@pd.tnic> <CAErSpo6fbMmicX95j_wYkJRnQeJEZ_jQSm76j9ZN4sHP0C2Yhg@mail.gmail.com>
 <20130729144046.GE6634@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 29 Jul 2013 08:50:19 -0600
Message-ID: <CAErSpo69wNc1h6PyJhFfhdFzz0GOiM=SCCfrm-WO5XDFTFzcHw@mail.gmail.com>
Subject: Re: [PATCH] APEI/ERST: Fix error message formatting
To: Borislav Petkov <bp@alien8.de>
Cc: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Anton Vorontsov <anton@enomsg.org>,
        Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>,
        Tony Luck <tony.luck@intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 29, 2013 at 8:40 AM, Borislav Petkov <bp@alien8.de> wrote:
> On Mon, Jul 29, 2013 at 08:28:05AM -0600, Bjorn Helgaas wrote:
>> > @@ -186,7 +186,7 @@ static int erst_exec_stall(struct apei_exec_context *ctx,
>> >
>> >         if (ctx->value > FIRMWARE_MAX_STALL) {
>> >                 if (!in_nmi())
>> > -                       pr_warning(FW_WARN ERST_PFX
>> > +                       pr_warn(FW_WARN
>> >                         "Too long stall time for stall instruction: %llx.\n",
>>
>> You didn't change this part, but this and similar messages look less
>> useful than they could be.  We're printing in hex, but there's no
>> indication in the output (no "0x" prefix).  And there's no instruction
>> pointer or anything to help connect this back to the source of the
>> problem.
>
> Sounds like we don't want to print ctx->value at all but simply signal
> about the stall? Or?

If I were the firmware developer and got a report about this message,
I think the information I would want is ctx->ip, so I could identify
the corresponding source code.  But I don't know much about the ERST
interpreter, so I don't know if "ctx->ip" is the right place to look.
Maybe there's a method name or table name that would be needed in
addition.

It just seems like "ERST: Too long stall time for stall instruction:
4732." all by itself doesn't really contain any actionable
information.

Bjorn
