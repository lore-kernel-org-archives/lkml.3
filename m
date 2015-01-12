Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbbALSzp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:55:45 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:59763 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbbALSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:55:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Rameshwar Sahu <rsahu@apm.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, ddutile@redhat.com,
        jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
Subject: Re: [PATCH v2 1/3] dmaengine: Add support for APM X-Gene SoC DMA engine driver
Date: Mon, 12 Jan 2015 19:55:02 +0100
Message-ID: <1701652.4qUlzcU1j2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAFd313xp5rZZZSSKk-DDTC4ccY9ZucGgmWrc9oG-TiK2FMBS1g@mail.gmail.com>
References: <1420628981-22774-1-git-send-email-rsahu@apm.com> <1420628981-22774-2-git-send-email-rsahu@apm.com> <CAFd313xp5rZZZSSKk-DDTC4ccY9ZucGgmWrc9oG-TiK2FMBS1g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:tCmhKtmbN7R8JaSzOA7dg3rQjkfA91Jn6+tCtxHXNP6f8cNXcoN
 KMBZbGJmqEBH/VOv2gXVTtzV9pipRfVsiD8pP2rxhbhKOVWNqGN8lok0TbHMrMRMs7vWeEr
 3W/TVdQFLV1GMceEc1IoyEvPyXXWWuB764Hh5lWk2aLAc+fpu1lGX5drG+HQ3cF/DhJ6IWK
 4mmCJeefeKUlYc/VUVTpQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 January 2015 14:40:09 Rameshwar Sahu wrote:
> > +
> > +       dma_set_mask_and_coherent(&pdev->dev,
> > +                                 (sizeof(dma_addr_t) == sizeof(u64)) ?
> > +                                 DMA_BIT_MASK(64) : DMA_BIT_MASK(32));
> > +
> 

I commented on this on v1 already: always set the device specific mask here,
it's independent of the CPU architecture, but do check the return value.

Also add the correct dma-ranges property in the parent, or else this will
fail in the future once we add proper checks to dma_set_mask.

	Arnd
