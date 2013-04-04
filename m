Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764074Ab3DDRkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:40:10 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:37543 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763865Ab3DDRkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:40:08 -0400
MIME-Version: 1.0
In-Reply-To: <515DB7F6.8010502@redhat.com>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
	<1365088091-10862-1-git-send-email-nhorman@tuxdriver.com>
	<CAE9FiQUq8m_2fpyRrLweCZwR7cqFBfbZrt9ZeK-PVL3Puxjp0g@mail.gmail.com>
	<515DB7F6.8010502@redhat.com>
Date: Thu, 4 Apr 2013 10:40:07 -0700
X-Google-Sender-Auth: TXAf080ezpULb12-PvTauUiMr10
Message-ID: <CAE9FiQVXG+ns00sCAKGY5Xs3BT3Cc=LRyEkZzHP9DQXS+4KCKg@mail.gmail.com>
Subject: Re: [PATCH v4] irq: add quirk for broken interrupt remapping on 55XX chipsets
From: Yinghai Lu <yinghai@kernel.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 10:27 AM, Don Dutile <ddutile@redhat.com> wrote:
>> You need to move the quirk to early_quirk to append nointremap to
>> avoid extra rebooting.
>>
> The pci-dev's of all the (minimally, root, 5500-chipset) pci-dev's are
> known/scanned/created by that time?

in arch/x86/kernel/early-quirk.c

and on top of
https://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/commit/?h=for-x86-early-quirk-usb&id=de38757e964cfee20e6da1977572a2191d7f4aa0

You could add one entry in early_qrk[].

Some one already try to use that path to disable x2apic on some thinkpad.

So it should work on nointrremap too.

Thanks

Yinghai
