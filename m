Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3B0Vky (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:40:54 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:46817 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab3B0Vkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:40:53 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] PCI changes for v3.9
Date: Wed, 27 Feb 2013 22:47:39 +0100
Message-ID: <1673357.1IdxNNvGWX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQUkMqqSE9JJuxt7MxLheQA1j2nKC7QfOB7xLEJ9iUhs7g@mail.gmail.com>
References: <20130223212120.GA4593@google.com> <CA+55aFy7PvVqAN6tLFFuCUALsXsKsuf-yqWso3aZGe4-MkFvuw@mail.gmail.com> <CAE9FiQUkMqqSE9JJuxt7MxLheQA1j2nKC7QfOB7xLEJ9iUhs7g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 26, 2013 10:14:29 AM Yinghai Lu wrote:
> On Tue, Feb 26, 2013 at 8:13 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Mon, Feb 25, 2013 at 10:46 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> >> On Mon, Feb 25, 2013 at 9:19 PM, Linus Torvalds
> >> <torvalds@linux-foundation.org> wrote:
> >>>
> >>> Also, my *gut* feel is that the new _handle_hotplug_event_root()
> >>> function should do that whole dance with
> >>> acpi_scan_lock_acquire()/acpi_scan_lock_release(), but I didn't really
> >>> know if it's required or appropriate, so I left it alone. Could you
> >>> take a look?
> >>
> >> Yes, we need that for root bridge hot add path.
> >>
> >> for hot remove path, we already have lock acquire/release in
> >> acpi_bus_hot_remove_device().
> >>
> >> Please check attached patch for hot add path.
> >
> > Quite frankly, doing this in handle_root_bridge_insertion() doesn't
> > match the pattern elsewhere. Elsewhere you also protected the whole
> > acpi_get_name() lookup etc. Which is why I felt that it would make
> > more sense to add this to _handle_hotplug_event_root().
> >
> > But there may be good reasons why the root bridge case is different,
> > and I don't have strong opinions, I just wanted people to look at his
> > case. I'll let you and Bjorn sort it out...
> 
> ok,
> 
> Bjorn, Rafael,
> 
> Can you please check if you are ok with attached patch ?

The patch looks correct to me.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
