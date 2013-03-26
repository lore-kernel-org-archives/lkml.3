Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243Ab3CZKTv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 06:19:51 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:47790 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756692Ab3CZKTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 06:19:49 -0400
Date: Tue, 26 Mar 2013 10:19:44 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 2/3] mfd: db8500-prcmu: Fetch the PRCMU TCDM base address
 from Device Tree
Message-ID: <20130326101944.GA15177@gmail.com>
References: <1364223758-17621-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdZxU197moM_00UQr-tHdip4b50c+CfYkR5OK+MbwsE-aw@mail.gmail.com>
 <20130326094848.GA14151@gmail.com>
 <201303261000.33615.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303261000.33615.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Mar 2013, Arnd Bergmann wrote:

> On Tuesday 26 March 2013, Lee Jones wrote:
> > Bit for information for you. 
> > 
> > I have confirmed that the address locations are the same for
> > all SoCs are the same. However, the size of the TCDM changes from 4k
> > on the db8500 to 12k on the db8540.
> > 
> > Is there a way we can increase the size for the db8540 without
> > creating an entire new DTS file? Seems overkill.
> 
> You can always override a property by setting it again, like
> 
> 	soc {
> 		prcmu: db8500-prcmu@abcd0000 {
> 			reg = <0xabcd0000 0x1000>;
> 		};
> 	};
> 
> ...
> 
> 
> 	&prcmu {
> 		reg = <0xabcd0000 0x3000>;
> 	}

Perfect, thanks.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
