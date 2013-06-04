Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3FDPPN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:15:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50171 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3FDPPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:15:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        linux-arm-kernel@lists.infradead.org,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] ARM: at91: Fix link breakage when !CONFIG_PHYLIB
Date: Tue, 04 Jun 2013 17:12:10 +0200
Message-ID: <1900947.vroxSJEyuA@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <51ADF5C8.80007@free-electrons.com>
References: <1369651702-9207-1-git-send-email-alexandre.belloni@free-electrons.com> <51ADF04D.3040703@atmel.com> <51ADF5C8.80007@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:ksNHQBDPhpdzSrNp31d1Z08usngHY6AcPb90LVtms/m
 fNNT6f57XRDPwlxgjUHkQlqXgy5Cqkyh183bAfxQ8yD2OJL5rP
 k7YbOhHUAXgGnjn2BBTs5OdqMSbaREja9L3O/wfcCZ7q+34xYt
 r7lMmJxKXeuVpPCIh/1F3jYVP7WqqKi/VFyDZB49kit/HsaWTX
 19eAbE2fNVy8buZ32d2JK1M6pMmspvSjNWKOlvar6v0ldDmnvk
 jAaccaY7CRPWWbrq5L/Z6GATsRIe0b85atRsC8VKsamaaehmZL
 HzQlBfFrf+FVda0GmrLSg1/5R5ZjLg+PfhlJLAV3B/T6EoMZhN
 rOVWh0kY7zCCFghgLPBg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 16:12:24 Alexandre Belloni wrote:
> On 04/06/2013 15:49, Nicolas Ferre wrote:
> >
> > ... simply use this "IS_BUILTIN(CONFIG_PHYLIB)" here -----^^^^^^^^^
> > (and not above as suggested by Arnd).
> >
> > Jean-Christophe, Alexandre: do you agree with this conclusion?
> >
> > I plan to stack this patch for next at91-fixes batch.
> >
> 
> Yeah, I prepared and tested that last week but didn't send it yet. I can
> do it now if you want but you could probably just edit my patch. I'd
> like to fix the other platforms too but that probably can wait.
> 
> I believe we would still have to fix the phy_register_fixup*() works as
> it is always called from arch/ and is clearly not fool proofed enough.
> Maybe DT could help ?
> 
> Arnd, do you have any input ?

I've replied to the earlier thread now. Using if(IS_ENABLED(CONFIG_NET))
or if(IS_ENABLED(CONFIG_PHYLIB)) in platform code should be just fine and
is not a lof of extra effort.

As I explained in the other mail, I think IS_ENABLED() is better than
IS_BUILTIN() because the case where the network driver is a loadable
module would cause a silent run-time error with IS_BUILTIN, but a
link time error with IS_ENABLED, and we can prevent that error by
correctly expressing the dependency in Kconfig, e.g.

config THIS_BOARD
	select PHYLIB if THIS_BOARDS_NIC

	Arnd
