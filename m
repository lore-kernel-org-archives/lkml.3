Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab3LVHEG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 02:04:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:53950 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3LVHED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 02:04:03 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Loc Ho <lho@apm.com>
Cc: Ravi Patel <rapatel@apm.com>, gregkh@linuxfoundation.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Jon Masters <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH V2 0/4] misc: xgene: Add support for APM X-Gene SoC Queue Manager/Traffic Manager
Date: Sun, 22 Dec 2013 08:03:07 +0100
Message-ID: <1441245.xPZLG2iNZ6@wuerfel>
User-Agent: KMail/4.11 rc1 (Linux/3.10.0-5-generic; KDE/4.11.2; x86_64; ; )
In-Reply-To: <CAPw-ZTnsu_EmOW3aZTVKAVjQsdi8qMy95y2ZcYxzgVrjGkirTA@mail.gmail.com>
References: <1387594651-25771-1-git-send-email-rapatel@apm.com> <201312212111.40576.arnd@arndb.de> <CAPw-ZTnsu_EmOW3aZTVKAVjQsdi8qMy95y2ZcYxzgVrjGkirTA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:suj4aZN/09ccX8jUbh1ltTH6O/EDcJgNiztO15lvZNV
 KHvTaBlC2nzEzNYnf5FHKcacpGU/sK8pJJAMJM27TriEEm+qXc
 wIsZDnS4TEJirFvL4KCzzSA5J3zPxpzZPs6Dvqw5FruQm/bNU4
 aQWmxqDCFUdJ8YkxgHozrAao+Sz2iSr/Uq7Opqjo2Cj3Sr5gUD
 vItPgIY2/Sy2+pGO4W4dLYCXGoAX2ahZn/r2dhYv957AE3LmTH
 hhoZnutNk0WKbV/IITWBxsD6jR8W2OGfTiBLVyGfYIhv/nk2+Z
 kWV5Ix8sGRst31ngWdcfJOk7P6gRv7sUSToXJSK8kpSDGhJlHz
 9NjVADi6tLo79lSSGgNw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 December 2013 17:00:51 Loc Ho wrote:
> On Sat, Dec 21, 2013 at 12:11 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> > On Saturday 21 December 2013, Ravi Patel wrote:
> >> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
> >>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA (XOR Engine) and
> >>  Security Engine subsystems. All subsystems communicate with QMTM using
> >>  messages which include information about the work to be performed and
> >>  the location of associated data buffers.
> >
> > Please describe here what the purpose of the qmtm is, as this is not
> > entirely clear from the code.
> >
> > In particular, please describe how this differs from a dmaengine driver
> > and why it is not possible to extend the dma slave API to describe qmtm
> > as a dma engine.
> >
> [Loc Ho]
> If the QM driver implements the DMA API, what about the actual DMA
> engine driver which interfaces with this QM driver. We would have DMA
> client interfaces with the X-Gene DMA driver (not available yet) via
> DMA API which in turn interfaces with this QM driver via DMA API.
> Won't this be kind of awkward? Also, the QM only manage messages (or
> descriptors) which are 32-bytes or 64-bytes. It doesn't actually do
> any data transfer of various sizes.

Please describe here what the purpose of the qmtm is, as this is not
entirely clear from the code or from your reply.

Greg was guessing that it's a bus controller, my best guess is a DMA
engine. If it's something completely different, you have to let
us know what it is so we can do a proper review rather than guessing.

Please provide a link to the data sheet if you are unable to explain.

	Arnd
