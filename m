Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaENSOa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 14:14:30 -0400
Received: from mout.kundenserver.de ([212.227.126.130]:62885 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910AbaENSO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 14:14:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Baruch Siach <baruch@tkos.co.il>,
        Wan ZongShun <mcuos.com@gmail.org>, linux-kernel@vger.kernel.org,
        Marek Vasut <marek.vasut@gmail.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c/nuc900: fix ancient build error
Date: Wed, 14 May 2014 20:14:23 +0200
Message-ID: <4944869.eRrWyMmW4d@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140514162725.GG12911@katana>
References: <1399560433-1402630-1-git-send-email-arnd@arndb.de> <1399560990-1402858-11-git-send-email-arnd@arndb.de> <20140514162725.GG12911@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SMIV/0trS+5RyKB1ttqW/f4aqwG0IGPZ2t1hmDqGVMC
 aAr36+AjIAhNFWdyXeVMCzb8btfazxln0HDC1+o52ufvBDT8Ov
 rFaPFvPCbp/rhUHIf4mSVOCrL5ct/YZsjt4R55dwxYSHyWFKbo
 KOejX2HOelqkYMGdO5uRauAHk6JEBqr3c50WkGV1RsnT/O+rzQ
 /K3NhJDjswbzHdI1dkj0B8DO8pLTjc0sc4QVYhfbKFz3kGZeqS
 +trfyp5219nCtxXpZ7bJcorWt1/BVf+M93w3AZw2MGX+XHzcjv
 32UzGpzIzyOjdKQf2hBcntWJYL3tYfsXvxxDO6T+3Drvry2pfC
 Abbg5Mw8mOjNgbOR2VUM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 18:27:25 Wolfram Sang wrote:
> On Thu, May 08, 2014 at 04:56:22PM +0200, Arnd Bergmann wrote:
> > As far as I can tell, this driver must have produced this error
> > for as long as it has been merged into the mainline kernel, but
> > it was never part of the normal build tests:
> > 
> > drivers/i2c/busses/i2c-nuc900.c: In function 'nuc900_i2c_probe':
> > drivers/i2c/busses/i2c-nuc900.c:601:17: error: request for member 'apbfreq' in something not a structure or union
> >   ret = (i2c->clk.apbfreq)/(pdata->bus_freq * 5) - 1;
> >                  ^
> > 
> > This is an attempt to get the driver to build and possibly
> > work correctly, although I do wonder whether we should just
> > remove it, as it has clearly never worked.
> 
> I'd go for removing. For this platform, the last patch which was not a
> generic cleanup seems to be from late 2011?

Ah, you mean removing the entire platform? I guess we could do that
as well, but I was really thinking of just removing the i2c driver.

For the moment, I'd leave this up to Wan ZongShun. He has in the past
at least replied to emails about the platform, even though there hasn't
been any new development.

	Arnd
