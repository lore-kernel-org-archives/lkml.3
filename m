Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754546AbaBDNUM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 08:20:12 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49566 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbaBDNUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 08:20:08 -0500
Message-ID: <52F0E8EC.8030900@ti.com>
Date: Tue, 4 Feb 2014 15:19:40 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Satish Patel <satish.patel@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <rob@landley.net>
Subject: Re: [PATCH v2 3/5] char: ti-usim: Add driver for USIM module on AM43xx
References: <1390192434-19386-1-git-send-email-satish.patel@ti.com> <1390192434-19386-4-git-send-email-satish.patel@ti.com>
In-Reply-To: <1390192434-19386-4-git-send-email-satish.patel@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Satish,

On 01/20/2014 06:33 AM, Satish Patel wrote:
> TI-USIM driver is a platform driver that provides a character
> driver interface to user applications.
> 
> It allows user applications to call IOCTL's to
> perform smart card operations.
> 
> Driver currently supports
> - ATR
> - T=0 & T=1 protocol
> - clock stop mode
> - smart card clock configuration
> - Tx/Rx application data units (APDU) to smart card
> - Interface to PHY using DT & phy interface
> 
> Validation is done with ACOS3 smart cards
> 
> Signed-off-by: Satish Patel <satish.patel@ti.com>
> ---
>  .../devicetree/bindings/ti-usim/ti-usim.txt        |   31 +
>  drivers/char/Kconfig                               |    7 +
>  drivers/char/Makefile                              |    1 +
>  drivers/char/ti-usim-hw.h                          |  863 +++++++++
>  drivers/char/ti-usim.c                             | 1859 ++++++++++++++++++++

ti-usim.c is a very large driver that does everything but looks like limited to TI hardware.
How about splitting it into generic stuff and hw specific glue logic so that most of the generic stuff
could be used by different hardware types.

>  include/linux/ti-usim.h                            |   98 +
>  6 files changed, 2859 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ti-usim/ti-usim.txt
>  create mode 100644 drivers/char/ti-usim-hw.h
>  create mode 100644 drivers/char/ti-usim.c
>  create mode 100644 include/linux/ti-usim.h
> 

cheers,
-roger

