Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab3DBADo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:03:44 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:45845 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab3DBADm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:03:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130401235256.GA31966@google.com>
References: <CAErSpo6v0mj9=Q13d=G4hho0mb9XTcsmefzke9fROYmZ7oBWxQ@mail.gmail.com>
	<CAE9FiQU7cDzJdHxmqhJNgc9UCsRLgvCFQpv8+fLxD79pLEUC5A@mail.gmail.com>
	<CAErSpo4ncW8rkcpDiccORZedj30m7jRmpXK+amfDGn_wjwt7EA@mail.gmail.com>
	<CAE9FiQVqKag2TGah7x_1MAJ+c0UWgywgM_jKUoOnh+rq3bwBhg@mail.gmail.com>
	<CAE9FiQVMgdj5edbR4qZny29fV9-bW_We_G4Wpn_yruDLQZiQiQ@mail.gmail.com>
	<20130329032200.GA11990@google.com>
	<CAE9FiQVu5QyxaKsYzzQoroQD=TvsziHzDOtoeg=FvhZ8HyN5yw@mail.gmail.com>
	<CAErSpo7ChfRiEn0eR1rf-mVheUS9Yf8f+j4n78PJcGYh+yMVgA@mail.gmail.com>
	<CAE9FiQXkDg7Y336S=DXoms44=5HLaiUx=sWviupz1fJmaDUEzQ@mail.gmail.com>
	<CAE9FiQU5c=ztzbskNnYFFKF9V5zO+jnRcMBCivLxA1F3fSfX5w@mail.gmail.com>
	<20130401235256.GA31966@google.com>
Date: Mon, 1 Apr 2013 17:03:41 -0700
X-Google-Sender-Auth: _Y8CJh1ExGjXXFFxZXLlHLXj-oA
Message-ID: <CAE9FiQV8cPh-s6=EQu_cZTtn86+NwZE5KuGMhf43aOhzkL=hwA@mail.gmail.com>
Subject: Re: [PATCH] PCI: Remove not needed check in disable aspm link
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Roman Yepishev <roman.yepishev@gmail.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 1, 2013 at 4:52 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Mar 29, 2013 at 11:04:48AM -0700, Yinghai Lu wrote:
>> attatched -v3 again
>>
>> > Please check attached -v3.
>
> It's getting late in the v3.9 cycle already, and while your v3 patch
> probably fixes Roman's problem, I can't convince myself that it is
> safe in general.
>
> I think the safest thing to do at this point is to revert 8c33f51df
> ("PCI/ACPI: Request _OSC control before scanning PCI root bus") with a
> patch like the one below.

Agreed.

>
> That does mean the booting path and hotplug paths will be different (we set
> aspm_disabled after boot but before hotplug), but it was that way for a
> long time before 8c33f51df.  I think it's more important to fix this recent
> ath5k regression than to fix a long-standing hotplug bug that nobody ever
> complained about.
>
> Obviously, I think we should fix the hotplug bug and clean up the ASPM
> mess, too.  But we need to do that when we have more time to do it right
> and test it.

Sure.

>
> Bjorn
>
>
> commit 96e5d01cd536458435ef0678d9fa3dc542afb41f
> Author: Bjorn Helgaas <bhelgaas@google.com>
> Date:   Mon Apr 1 15:47:39 2013 -0600
>
>     Revert "PCI/ACPI: Request _OSC control before scanning PCI root bus"
>
>     This reverts commit 8c33f51df406e1a1f7fa4e9b244845b7ebd61fa6.
>
>     Conflicts:
>         drivers/acpi/pci_root.c
>
>     Reference: https://bugzilla.kernel.org/show_bug.cgi?id=55211
>     Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

Acked-by: Yinghai Lu <yinghai@kernel.org>

stable need this reverting too.

Yinghai
