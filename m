Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3KJVpr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Nov 2013 16:45:47 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:38603 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3KJVph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Nov 2013 16:45:37 -0500
Date: Sun, 10 Nov 2013 22:45:35 +0100
From: Andreas Mohr <andi@lisas.de>
To: =?us-ascii?B?PT9HQjIzMTI/Qj91cXZBMmc9PT89?= <bonben1989@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How can I get the sector count in kernel?
Message-ID: <20131110214535.GA30532@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK2Ky6zxYAuiiDHwOHcbUzZ9B+jCj_ZEUpKd0YcQaHGw3QF4Yw@mail.gmail.com>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again :)

> I need the count of sector,but I don't know how to get it.
> Could you give me some favour?

First, you should ask yourself whether you really need this
drive-specific information.


Such information can (more or less) be gathered via the HDIO_GETGEO
ioctl. But be advised that this ioctl is known to be
unreliable/undesirable and will be handled differently
(and with differing reliability!!!) by various I/O layers.
E.g. this will be handled by a callback, which in the case of libata
will return values that are hard-coded for *LBA-specific* disk geometry
(255 heads).
Good luck if your disk happens to be using CHS or ECHS, where this value
likely is NOT the proper one. Especially in the case of ntfsclone /
partclone.ntfsfixboot combo this is a major nuisance (and you'll
probably end up having to manually specify the actually correct values
in order to finally get that f***in' thing to boot properly).

Also, you should make sure to be using the EDD BIOS service (see modinfo edd),
for the kernel to be able to forward actual BIOS-side drive geometry
information.

Another way to be gathering a geometry is by parsing geometry output
of fdisk / cfdisk.

HTH,

Andreas Mohr
