Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbaCHNG4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 08:06:56 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:46630 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087AbaCHNGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 08:06:55 -0500
Message-ID: <531B1603.6080106@gmail.com>
Date: Sat, 08 Mar 2014 21:07:15 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Suggestion] Makefile: about allmodconfig issue.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All:

"A module selects GENERIC_IRQ_CHIP and depend on IRQ_DOMAIN". For me,
it is a reasonable selection and dependency, but "make allmodconfig"
will report error. I guess it is the "Makefile allmodconfig" issue.

The related error report:

  [root@gchen linux-next]# make ARCH=avr32 CROSS_COMPILE=/usr/local/bin/avr32-linux-  allmodconfig
    HOSTCC  scripts/basic/fixdep
    HOSTCC  scripts/kconfig/conf.o
    SHIPPED scripts/kconfig/zconf.tab.c
    SHIPPED scripts/kconfig/zconf.lex.c
    SHIPPED scripts/kconfig/zconf.hash.c
    HOSTCC  scripts/kconfig/zconf.tab.o
    HOSTLD  scripts/kconfig/conf
  scripts/kconfig/conf --allmodconfig Kconfig
  kernel/time/Kconfig:162:warning: range is invalid
  kernel/irq/Kconfig:41:error: recursive dependency detected!
  kernel/irq/Kconfig:41:  symbol GENERIC_IRQ_CHIP is selected by GPIO_DWAPB
  drivers/gpio/Kconfig:131:       symbol GPIO_DWAPB depends on IRQ_DOMAIN
  kernel/irq/Kconfig:46:  symbol IRQ_DOMAIN is selected by GENERIC_IRQ_CHIP
  

The related commit (7779b34 gpio: add a driver for the Synopsys DesignWare APB GPIO block):  

  +config GPIO_DWAPB
  +       tristate "Synopsys DesignWare APB GPIO driver"
  +       select GPIO_GENERIC
  +       select GENERIC_IRQ_CHIP
  +       depends on OF_GPIO && IRQ_DOMAIN



Welcome any suggestions, discussions and completions.

Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
