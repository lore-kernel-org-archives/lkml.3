Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964809Ab3E1R3R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 13:29:17 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:40816 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964786Ab3E1R3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 13:29:14 -0400
MIME-Version: 1.0
In-Reply-To: <20130528164801.GA2345@srcf.ucam.org>
References: <1369215782-32697-1-git-send-email-matt@console-pimps.org>
 <CAErSpo4id0RFARD6zCxeMo-uasPBnL7KpUFPqhW4zLgCxrF5fw@mail.gmail.com>
 <20130528113617.GR14575@console-pimps.org> <CAErSpo5DG61wvQEw_9z8vm6Lp=E0urq6LG5SOuWSawkNeDkF+A@mail.gmail.com>
 <20130528164801.GA2345@srcf.ucam.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 May 2013 11:28:54 -0600
Message-ID: <CAErSpo5kxE=KgCV+H9=paaRXS1tOxhSD8qRf+nsn8PBMRiGRsA@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: setup data may be in highmem
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 10:48 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, May 28, 2013 at 10:31:51AM -0600, Bjorn Helgaas wrote:
>> On Tue, May 28, 2013 at 5:36 AM, Matt Fleming <matt@console-pimps.org> wrote:
>> > On Fri, 24 May, at 08:38:10AM, Bjorn Helgaas wrote:
>> >> pcibios_add_device() is mostly called at boot-time, when
>> >> early_ioremap() probably works well.  But it's also called when we
>> >> hot-add devices later, and it looks like early_ioremap() will then
>> >> generate warnings because "system_state != SYSTEM_BOOTING".
>> >
>> > Oops. Good point. Is there any reason we can't use ioremap()?
>>
>> I assume Matthew had some reason for avoiding that in the first place,
>> so I hope he'll chime in.
>
> I have no recollection of why I did it that way. If this is all
> happening late enough for ioremap() to work then that sounds fine.

OK, hopefully somebody will do the analysis to verify that ioremap()
is appropriate in both cases.  It seems likely, but I haven't looked
in detail.

Bjorn
