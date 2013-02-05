Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944Ab3BEPNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 10:13:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65244 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab3BEPNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 10:13:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
Cc: Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        alan@lxorguk.ukuu.org.uk, geert@linux-m68k.org,
        dahinds@users.sourceforge.net
Subject: Re: [PATCH] drivers/block/xsysace - replace in(out)_8/in(out)_be16/in(out)_le16 with generic iowrite(read)8/16(be)
Date: Tue, 05 Feb 2013 16:12:35 +0100
Message-ID: <7613336.0C5oRATusX@wuerfel>
User-Agent: KMail/4.10 rc3 (Linux/3.8.0-3-generic; KDE/4.9.98; x86_64; ; )
In-Reply-To: <51111133.7000105@synopsys.com>
References: <1359475380-31512-1-git-send-email-abrodkin@synopsys.com> <CAHTX3dLJy314mv39hprkmZ5XdzYiYGz1ngTERp7w6aAYud+Riw@mail.gmail.com> <51111133.7000105@synopsys.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:je5S1aZ+DCYPJc5UDTux2eXSjsjLd519W/tgpjWmDkl
 wy8ouWarF1G+tdD7oSxmlNq7BqLQupgPOjbRwtvsR6sckI1vH1
 CdkckcF3gfisTNueZ2WFxVzClmHpS0HZJEmuWdUw7zevuZjVKD
 MotT2ejbbUC5DX7jGuvif6pmXaSSJFRlxr37K2tiPYyKcrRuOZ
 eK2WHxZhnHXfo8yK5TaMrQt1D0nMr6mC96WCyQPTxXmFJ6NnFZ
 fif+qWk29DOxdw886j+NantkKVXsjSVI5PV+IPDTujOwIG1Sy+
 aAMHoCkQRD1asuEzBkiMqH/o9sCbMY3GaQZUfC84fYpAMFZYrn
 bXn7Aw4ZHaju56LzaJww=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 18:03:31 Alexey Brodkin wrote:
> The Xilinx System ACE Compact Flash chip is a true little-endian device 
> and the PLB is a big-endian bus. Therefore the XPS System ACE Interface 
> Controller will do a bit-swap in each byte when connecting the PLB data 
> bus to the System ACE data bus as shown in Table 2.
> 
> Note however, that the XPS System ACE Interface Controller does not 
> perform the byte swapping necessary to interface to a little-endian 
> device when configured to use 16-bit mode. Therefore, the software 
> drivers provided for this core will perform the necessary byte-swapping 
> to correctly interface to the Xilinx System ACE Compact Flash chip as 
> shown in Table 3.

Ok. In this case, I would recommend making the default for this driver
little-endian, and adding a quirk for broken hardware bridges like the
one you cited to have a mixed-endian mode if configured so at compile
time.

It seems that on all normal platforms, this device should behave as
little-endian, while the Xilinx bridge can be either big-endian
or little-endian, depending on whether it is used in 8-bit or 16-bit
mode, so if we are using this, it cannot be known at compile time.

	Arnd
