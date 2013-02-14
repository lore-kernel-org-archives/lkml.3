Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934132Ab3BNRSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 12:18:12 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:61311 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758097Ab3BNRSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 12:18:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130214143905.GC5700@pd.tnic>
References: <20130129202848.GE25415@pd.tnic> <3066730.6MVSAfNyye@vostro.rjw.lan>
 <20130131131034.GF4926@pd.tnic> <2293454.v8QRHr8txR@vostro.rjw.lan>
 <20130203144656.GB5844@pd.tnic> <20130214143905.GC5700@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 14 Feb 2013 10:17:46 -0700
Message-ID: <CAErSpo6Mi31O1YA5PKnRjQMinB284Ag6PY8LuZpD0NwuZ6QZuw@mail.gmail.com>
Subject: Re: Uhhuh. NMI received for unknown reason 2c on CPU 0.
To: Borislav Petkov <bp@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jiri Slaby <jslaby@suse.cz>, Bjorn Helgaas <bhelgaas@google.com>,
        x86@kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2013 at 7:39 AM, Borislav Petkov <bp@suse.de> wrote:
> On Sun, Feb 03, 2013 at 03:46:56PM +0100, Borislav Petkov wrote:
>> On Sun, Feb 03, 2013 at 12:04:46AM +0100, Rafael J. Wysocki wrote:
>> > The [2/5] is at: https://patchwork.kernel.org/patch/2001211/
>> >
>> > The other two are attached.  I suppose the ordering doesn't matter.
>>
>> Ok, the eth link cable hotplugging issue seems fixed, plugging and
>> unplugging the cable works as expected.
>
> Q: what happened to those, are they going upstream for 3.9 or are you
> sending them now for 3.8?
>
> They fix at least the cable hotplugging issue so at least one thing is
> covered.

I haven't done anything with the e1000e patches; I assume the e1000e
maintainers will take care of those.

I merged the following patches for v3.9:

    * pci/konstantin-runtime-pm:
      PCI/PM: Clear state_saved during suspend
      PCI: Use atomic_inc_return() rather than atomic_add_return()
      PCI: Catch attempts to disable already-disabled devices
      PCI: Disable Bus Master unconditionally in pci_device_shutdown()

You can see the actual patches I merged at:
http://git.kernel.org/?p=linux/kernel/git/helgaas/pci.git;a=shortlog;h=refs/heads/next

It's pretty late for v3.8, but let me know if you think they're critical.

Bjorn
