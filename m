Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab3DZMGE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 08:06:04 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54935 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3DZMGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 08:06:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Yann E. MORIN" <yann.morin.1998@free.fr>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sam Ravnborg <sam@ravnborg.org>, Arnaud Lacombe <lacombar@gmail.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 6/8] kconfig: fix randomising choice entries in presence of KCONFIG_ALLCONFIG
Date: Fri, 26 Apr 2013 14:05:37 +0200
Message-ID: <6079984.JVoK3fHgsy@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <422c809f03f043d0950d8362214818e956a9daee.1366841993.git.yann.morin.1998@free.fr>
References: <cover.1366841993.git.yann.morin.1998@free.fr> <422c809f03f043d0950d8362214818e956a9daee.1366841993.git.yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:A+Q3eNKV+KsCZjZ+3YeDmxSR3w4Sw/yeDDgWe//4cJd
 fCqowb4m6ic1f9UgaayQUe1CzX4qszkYa/S0Fcf83NeBidyuIq
 DZ/ET3aD+0HRlRW+GrxjTeOKjGo2BQ9tUA5Iul/3TaOSJEQZF5
 M8OdJnQosKpibcvK1wpUtTgkArsgayeRw/GyYx2+ZJ/7MO1QhX
 OAAjKCrc9GjoJoXtMCVSZVcfkaiX/yI1iRyGbPxyDnnBOCrYXo
 LmIL3r9CeI73WjCfSE3VGG5mV+j0EHNyk3uH83rCgV1L7bKeJl
 vyxqgagF7wv1AKpSPCt5rvVKH8y6P7T+iwSPXNxxL4cY+L8nY5
 EZBVaJu4kB0Zua4p4arw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 April 2013 00:29:53 Yann E. MORIN wrote:
> From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> 
> Currently, randconfig does randomise choice entries, unless KCONFIG_ALLCONFIG
> is specified.
> 
> For example, given those two files (Thomas' test-case):

This patch has made it into linux-next today, and while I agree with
the basic idea, it seems to cause regressions for me.

For these ARM defconfigs, 'make' always asks about USB_GADGET now
after doing any of these defconfigs:

am200epdkit_defconfig
at91_dt_defconfig
at91rm9200_defconfig
at91sam9260_defconfig
at91sam9261_defconfig
at91sam9263_defconfig
at91sam9g20_defconfig
at91sam9g45_defconfig
corgi_defconfig
ezx_defconfig
h5000_defconfig
imote2_defconfig
kzm9g_defconfig
lpc32xx_defconfig
lubbock_defconfig
mackerel_defconfig
magician_defconfig
mini2440_defconfig
msm_defconfig
omap1_defconfig
prima2_defconfig
sama5_defconfig
tct_hammer_defconfig

~/arm-soc$ make at91_dt_defconfig
make[1]: Entering directory `/git/arm-soc'
  GEN     /git/arm-soc/obj-tmp/Makefile
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
#
# configuration written to .config
#
make[1]: Leaving directory `/git/arm-soc'
~/arm-soc$ make -sj40
make[1]: Entering directory `/git/arm-soc'
  GEN     /git/arm-soc/obj-tmp/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
*
* Restart config...
*
*
* USB Gadget Support
*
USB Gadget Support (USB_GADGET) [Y/n/m/?] y
  Debugging messages (DEVELOPMENT) (USB_GADGET_DEBUG) [N/y/?] n
  Debugging information files (DEVELOPMENT) (USB_GADGET_DEBUG_FILES) [N/y/?] n
  Debugging information files in debugfs (DEVELOPMENT) (USB_GADGET_DEBUG_FS) [N/y/?] n
  Maximum VBUS Power usage (2-500 mA) (USB_GADGET_VBUS_DRAW) [2] 2
  Number of storage pipeline buffers (USB_GADGET_STORAGE_NUM_BUFFERS) [2] 2
  USB Gadget Drivers [M/y/?] (NEW) 

I'm taking Greg on Cc here so he's aware of the problem and knows it's
not caused by any of the USB Kconfig changes that I and others submitted
recently. It took me a while to confirm that it's just your patch and
not mine that caused the problem.

	Arnd
