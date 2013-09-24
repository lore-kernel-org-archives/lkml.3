Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab3IXTFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 15:05:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56809 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374Ab3IXTFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 15:05:34 -0400
Message-ID: <5241E26B.3080901@infradead.org>
Date: Tue, 24 Sep 2013 12:05:15 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anatolij Gustschin <agust@denx.de>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Sep 24 (video/mb862xx)
References: <20130924144341.772ef648fe8ea2137160596f@canb.auug.org.au>
In-Reply-To: <20130924144341.772ef648fe8ea2137160596f@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 21:43, Stephen Rothwell wrote:
> Hi all,
> 
> 
> Changes since 20130923:
> 

on i386:

when CONFIG_I2C=m and
CONFIG_FB_MB862XX=y
CONFIG_FB_MB862XX_PCI_GDC=y
CONFIG_FB_MB862XX_I2C=y


drivers/built-in.o: In function `mb862xx_i2c_init':
(.text+0x68a1c): undefined reference to `i2c_add_adapter'
drivers/built-in.o: In function `mb862xx_i2c_exit':
(.text+0x68a6e): undefined reference to `i2c_del_adapter'


Caused by this kconfig bool:
config FB_MB862XX_I2C
	bool "Support I2C bus on MB862XX GDC"
	depends on FB_MB862XX && I2C
	default y

which == 'y' even when CONFIG_I2C = m.




-- 
~Randy
