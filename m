Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbbAET0b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 14:26:31 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41000 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753504AbbAET03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 14:26:29 -0500
MIME-Version: 1.0
In-Reply-To: <20150105184821.GA703@rhlx01.hs-esslingen.de>
References: <1420424374-32412-1-git-send-email-robh@kernel.org> <20150105184821.GA703@rhlx01.hs-esslingen.de>
From: Rob Herring <robh@kernel.org>
Date: Mon, 5 Jan 2015 13:26:07 -0600
X-Google-Sender-Auth: 5moo3aVL6LznzfEm_S2pzDS3Kh8
Message-ID: <CAL_JsqKoMHDmTjbZdoTD9gCO5x8Yqw3+8tofJ=MB0RbasnCPtQ@mail.gmail.com>
Subject: Re: [PATCH] pci: introduce common pci config space accessors
To: Andreas Mohr <andi@lisas.de>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Will Deacon <will.deacon@arm.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 12:48 PM, Andreas Mohr <andi@lisas.de> wrote:
> Hi,
>
>> +     if (size == 1)
>> +             *val = readb(addr);
>> +     else if (size == 2)
>> +             *val = readw(addr);
>> +     else
>> +             *val = readl(addr);
> (pci_generic_config_read() and pci_generic_config_write())
>
> switch()
> default: WARN_ON(1);
> ?

If you look at PCI_OP_READ/PCI_OP_WRITE defines, the caller can only
have size of 1, 2 or 4. AFAIK, config accesses don't go thru any other
caller.

Rob
