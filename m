Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933675Ab3BLSB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:01:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61798 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933589Ab3BLSBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:01:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: [PATCH 05/32] lib: devres: don't enclose pcim_*() functions in CONFIG_HAS_IOPORT
Date: Tue, 12 Feb 2013 18:00:48 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-5-generic; KDE/4.3.2; x86_64; ; )
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "Eran Ben-Avi" <benavi@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
References: <1360686546-24277-1-git-send-email-thomas.petazzoni@free-electrons.com> <1360686546-24277-6-git-send-email-thomas.petazzoni@free-electrons.com>
In-Reply-To: <1360686546-24277-6-git-send-email-thomas.petazzoni@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302121800.48723.arnd@arndb.de>
X-Provags-ID: V02:K0:OMtpggWRMqS6dJ/qSz/b7t7iUgCMnpKVCUVu2wRI1g8
 RkgjTvxJzqrML76HDT6pcMQPnfM+7u8UU5jolfhHqLgfWpI/UX
 CMhGKrIic1XZwEPYnUeoDEWgpL9SQwFPrmrcCaZ3Rqb0tKivXO
 NAKHU6dXOmd9ZbZB9fwraZnyz2a/rf15AK+jf3aG60NB7PVFZN
 SYx78q2OOlNfNRlxT/E6dYdteC5WoUZggpjSv6m1iSNVGHa4cT
 Qb/iOrR6hOAAVoDaw21pzTPldQe+oPprf+o82SeLZ9iSv3Cy3g
 OcmBlhgnQrTeNNUFHS47j0KXmk3CLrWTgyGAAnfnMXcGHpGYWo
 R5Hw3ef5oAXU7KhZAoz8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2013, Thomas Petazzoni wrote:
> The pcim_*() functions are used by the libata-sff subsystem, and this
> subsystem is used for many SATA drivers on ARM platforms that do not
> necessarily have I/O ports.
> 
> Signed-off-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: linux-kernel@vger.kernel.org

Sorry, but this patch is still incorrect. Any driver that requires a linear
mapping of I/O ports to __iomem pointers must depend CONFIG_HAS_IOPORT
with the current definition of that symbol (as mentioned before, we
should really rename that to CONFIG_HAS_IOPORT_MAP). Having these
functions not defined is a compile time check that is necessary to
ensure that all drivers have the correct annotation.

If a platform has no support for I/O ports at all, it should
probably not set CONFIG_NO_IOPORT at this point.

	Arnd
