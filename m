Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab3HBU2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:28:30 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:64012 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751508Ab3HBU22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:28:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130802181740.GA27100@google.com>
References: <20130802181740.GA27100@google.com>
Date: Fri, 2 Aug 2013 13:28:25 -0700
X-Google-Sender-Auth: P99mqTT7lk4qwXjzUWNvp836Kfk
Message-ID: <CA+55aFzSG8ny=79_MFik5xP99c7eb-LMKh0JzTKpbiEB8Wt=5Q@mail.gmail.com>
Subject: Re: [GIT PULL] PCI updates for v3.11
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bjorn Helgaas <bhelgaas@google.com>, Michal Marek <mmarek@suse.cz>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 2, 2013 at 11:17 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>
> Yinghai is still working on another SR-IOV-related fix or two, which
> will be simpler if pciehp is non-modular, so I included the Kconfig
> changes now to get them in earlier.

Hmm. Doing a trivial "make allmoconfig" for testing, I get

  include/config/auto.conf:3014:warning: symbol value 'm' invalid for
HOTPLUG_PCI_PCIE
  include/config/auto.conf:4711:warning: symbol value 'm' invalid for
HOTPLUG_PCI

but that may be a build system issue with stale data from the
*previous* "make allmodconfig". Regardless, that makes me worried.

Adding Michal Marek to the discussion. I'm currently doing a new "make
allmodconfig" after having done a "git clean -dqfx" to see if the
error remains. If it does, I will unpull. If it is gone, I'm going to
assume the Kconfig changes are ok, but that our build system is
missing some dependency.

Michal? I haven't pushed things out yet (and that allmodconfig build
from scratch will take 20 min or so), but you can recreate my tree by
pulling that pci thing locally from:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git
tags/pci-v3.11-fixes-1

Ho humm..

                     Linus
