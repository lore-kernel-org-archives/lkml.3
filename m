Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaCHPE1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 10:04:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48867 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaCHPE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 10:04:26 -0500
Message-ID: <531B3178.8000804@infradead.org>
Date: Sat, 08 Mar 2014 07:04:24 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] Makefile: about allmodconfig issue.
References: <531B1603.6080106@gmail.com>
In-Reply-To: <531B1603.6080106@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2014 05:07 AM, Chen Gang wrote:
> Hello All:
> 
> "A module selects GENERIC_IRQ_CHIP and depend on IRQ_DOMAIN". For me,
> it is a reasonable selection and dependency, but "make allmodconfig"
> will report error. I guess it is the "Makefile allmodconfig" issue.
> 
> The related error report:
> 
>   [root@gchen linux-next]# make ARCH=avr32 CROSS_COMPILE=/usr/local/bin/avr32-linux-  allmodconfig
>     HOSTCC  scripts/basic/fixdep
>     HOSTCC  scripts/kconfig/conf.o
>     SHIPPED scripts/kconfig/zconf.tab.c
>     SHIPPED scripts/kconfig/zconf.lex.c
>     SHIPPED scripts/kconfig/zconf.hash.c
>     HOSTCC  scripts/kconfig/zconf.tab.o
>     HOSTLD  scripts/kconfig/conf
>   scripts/kconfig/conf --allmodconfig Kconfig
>   kernel/time/Kconfig:162:warning: range is invalid
>   kernel/irq/Kconfig:41:error: recursive dependency detected!
>   kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
>   drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
>   kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP
>   
> 
> The related commit (7779b34 gpio: add a driver for the Synopsys DesignWare APB GPIO block):  
> 
>   +config GPIO_DWAPB
>   +       tristate "Synopsys DesignWare APB GPIO driver"
>   +       select GPIO_GENERIC
>   +       select GENERIC_IRQ_CHIP
>   +       depends on OF_GPIO && IRQ_DOMAIN
> 
> 
> 
> Welcome any suggestions, discussions and completions.
> 
> Thanks.
> 

A patch has already been submitted and applied by the subsystem maintainer.

http://marc.info/?l=linux-gpio&m=139413626320431&w=2


-- 
~Randy
