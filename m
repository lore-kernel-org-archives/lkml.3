Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab3LOJ0W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Dec 2013 04:26:22 -0500
Received: from nikam.ms.mff.cuni.cz ([195.113.20.16]:52307 "EHLO
	nikam.ms.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753275Ab3LOJ0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Dec 2013 04:26:20 -0500
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Dec 2013 04:26:20 EST
Date: Sun, 15 Dec 2013 10:18:39 +0100
From: Martin Mares <mj@ucw.cz>
To: Kay Sievers <kay@vrfy.org>
Cc: Tom Gundersen <teg@jklm.no>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH RESEND][pciutils] libpci: pci_id_lookup - add udev/hwdb
 support
Message-ID: <mj+md-20131215.091609.28546.nikam@ucw.cz>
References: <1378302428-19758-1-git-send-email-teg@jklm.no>
 <mj+md-20130904.134928.12262.nikam@ucw.cz>
 <CAG-2HqWcnZ-z7EbDd0aAj6y_Ho6szfRZUiK0psEnmoz17Kw-xA@mail.gmail.com>
 <mj+md-20131110.114139.9646.albireo@ucw.cz>
 <CAG-2HqXsEBB_nxUF4gza-eTsUjmysYR7iPEjJPUFyR1rC2KGMg@mail.gmail.com>
 <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP12MLL_Z5gyrCndQLRT6SR_TJi9xHp1HkHMX1ahwnxx3yw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kay,

> Libpci and its linear search through megabytes of text files for evey
> new query is too inefficient, that we cannot afford to use it during
> early bootup. It was the largest hit left in bootup profiling on
> machines booting userspace in the sub-1-second range on common
> machines. It was probably never meant to provide efficient queries,
> but it's the reason we can never use it during early boot.

I do not know what you are speaking about -- libpci definitely does
not perform linear scans on pci.ids. It builds a hash table from pci.ids
on the first query and and all subsequent queries are O(1) on average.

				Martin
