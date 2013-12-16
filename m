Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab3LPTMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 14:12:39 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42908 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab3LPTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 14:12:35 -0500
MIME-Version: 1.0
In-Reply-To: <1387206956.8071.14.camel@ejdallLaptop>
References: <1386948196-9409-1-git-send-email-betty.dall@hp.com>
 <20131213221616.GC6746@google.com> <1386974853.10497.64.camel@ejdallLaptop>
 <20131213230657.GD6746@google.com> <1387206956.8071.14.camel@ejdallLaptop>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 16 Dec 2013 12:12:14 -0700
Message-ID: <CAErSpo4rDNkqXTDvwD3masQUgy9vTxG97dBXMnLYzTdpEM5b9A@mail.gmail.com>
Subject: Re: [PATCH] PCI AER: Handle non-AER HEST error sources in aer_hest_parse()
To: Betty Dall <betty.dall@hp.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 8:15 AM, Betty Dall <betty.dall@hp.com> wrote:
> On Fri, 2013-12-13 at 16:06 -0700, Bjorn Helgaas wrote:
>
>> I should have thought longer before hitting send.  I think it's worthwhile
>> to use the same helper in aer_hest_parse_aff(), and once I did that, it
>> became more obvious that aer_hest_parse() and aer_hest_parse_aff() are
>> essentially similar, so I wonder if it's worth consolidating them, as
>> below.  It doesn't reduce the number of lines of code, but maybe it's
>> simpler for the reader?
>
>
> Hi Bjorn,
>
> That is a nice cleanup. I tested it on my firmware first system.
>
> Also, I double checked back through the ACPI spec, and there are
> FIRMWARE_FIRST flags in the IA-32 Architecture Machine Check Exception
> and IA-32 Architecture Corrected Machine Check error sources too. These
> functions we are changing are specifically looking just for the AER
> error sources. That is correct because AER firmware first is separate
> from MCE/CMC firmware first. So, this patch looks good.

Thanks, I added your "Reviewed-by".

Bjorn
