Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751594Ab3FYSby (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:31:54 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:63157 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3FYSbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:31:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130625183123.GJ9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
	<1372177330-28013-6-git-send-email-mika.westerberg@linux.intel.com>
	<CAHp75Vd2Torku6zy2awLHRTed9mx94a6RAu+oHJYb+rVgZKBDQ@mail.gmail.com>
	<20130625183123.GJ9294@intel.com>
Date: Tue, 25 Jun 2013 21:31:52 +0300
Message-ID: <CAHp75Vc8BauuBJcfqBzu_+6nUwEC-uD3z_RF5gT-3YhV0fjTqw@mail.gmail.com>
Subject: Re: [PATCH 5/6] PCI: acpiphp: look _RMV method a bit deeper in the hierarhcy
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, john.ronciak@intel.com,
        miles.j.penner@intel.com, bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 9:31 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:
> On Tue, Jun 25, 2013 at 09:15:47PM +0300, Andy Shevchenko wrote:
>> On Tue, Jun 25, 2013 at 7:22 PM, Mika Westerberg
>> <mika.westerberg@linux.intel.com> wrote:

[]

>> > +static acpi_status pcihp_evaluate_rmv(acpi_handle handle, u32 lvl,
>> > +                                     void *context, void **return_not_used)
>> > +{
>> > +       unsigned long long *removable = context;
>> > +       unsigned long long value;
>> > +       acpi_status status;
>> > +
>> > +       status = acpi_evaluate_integer(handle, "_RMV", NULL, &value);
>> > +       if (ACPI_SUCCESS(status) && value) {
>>
>> So, there is a chance the caller gets back uninitialized *context.
>> Let's assume that is by design.
>>
>> > +               *removable = value;
>> > +               return AE_CTRL_TERMINATE;
>> > +       }
>> > +       return AE_OK;
>> > +}
>>
>>
>> > +static bool pcihp_is_removable(acpi_handle handle, size_t depth)
>> > +{
>> > +       unsigned long long removable = 0;
>> > +       acpi_status status;
>> > +
>> > +       status = pcihp_evaluate_rmv(handle, 0, &removable, NULL);
>> > +       if ((status == AE_CTRL_TERMINATE) && removable)
>>
>> Here you already have removable not equal zero.
>
> Hmm, removable is initialized to zero just few lines above... Did I miss
> something obvious?

Yes, that's correct, however, you already did this check when you call
evaluate_rmv. Thus, second check '&& removable' is not needed.

--
With Best Regards,
Andy Shevchenko
