Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3BZQNn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:13:43 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:62843 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758711Ab3BZQNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:13:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUT+iHHZwn-2OsoJX0zXJ6rt6n0zuT+mLP=M8yFMxmMdg@mail.gmail.com>
References: <20130223212120.GA4593@google.com>
	<CAE9FiQWDktthNN3aCq-+tqWJU+Cz+PjN57E=pHzBBErCsZ8B7Q@mail.gmail.com>
	<CA+55aFx7jq7ruTN+pnp-4hPHnkr1G-1WAiAJSQYTPr7GOJjExw@mail.gmail.com>
	<CAE9FiQUT+iHHZwn-2OsoJX0zXJ6rt6n0zuT+mLP=M8yFMxmMdg@mail.gmail.com>
Date: Tue, 26 Feb 2013 08:13:40 -0800
X-Google-Sender-Auth: OuMj1sEDztf_U0bcnxajsU1FZWs
Message-ID: <CA+55aFy7PvVqAN6tLFFuCUALsXsKsuf-yqWso3aZGe4-MkFvuw@mail.gmail.com>
Subject: Re: [GIT PULL] PCI changes for v3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 10:46 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Mon, Feb 25, 2013 at 9:19 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Also, my *gut* feel is that the new _handle_hotplug_event_root()
>> function should do that whole dance with
>> acpi_scan_lock_acquire()/acpi_scan_lock_release(), but I didn't really
>> know if it's required or appropriate, so I left it alone. Could you
>> take a look?
>
> Yes, we need that for root bridge hot add path.
>
> for hot remove path, we already have lock acquire/release in
> acpi_bus_hot_remove_device().
>
> Please check attached patch for hot add path.

Quite frankly, doing this in handle_root_bridge_insertion() doesn't
match the pattern elsewhere. Elsewhere you also protected the whole
acpi_get_name() lookup etc. Which is why I felt that it would make
more sense to add this to _handle_hotplug_event_root().

But there may be good reasons why the root bridge case is different,
and I don't have strong opinions, I just wanted people to look at his
case. I'll let you and Bjorn sort it out...

                Linus
