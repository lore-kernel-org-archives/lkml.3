Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755644AbaGXLpK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:45:10 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:52412 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbaGXLpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:45:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Kweh Hock Leong <hock.leong.kweh@intel.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Chew Chiau Ee <chiau.ee.chew@intel.com>,
        Darren Hart <dvhart@linux.intel.com>, chiauee85@gmail.com,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] spi/pxa2xx-pci: Enable DMA binding through device name
Date: Thu, 24 Jul 2014 13:42:10 +0200
Message-ID: <10365151.12bEvS9Gvj@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
References: <1406196111-22861-1-git-send-email-hock.leong.kweh@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:LTcsXWsWUFFGZsO7TutejYSnwXv6LVhZHNuoIrPDHuc
 S9hCcvtAJyANyloDmaMbVIO71RfVbu4t6k+PvJSyHbf+BajtA/
 0W/xpMvXBgjjZEPF9I9+cuxpfRQLlcWjhWQF+okmj5axTKwdM4
 fZ2VriS2k5G75AxaRLlw8ActK9tMGFmFQGpFXaXvdRm0oqNdbZ
 IL/SFOiy3lNBcTUmCYIO94llKyhP3VplyW+f+9N7Kp62Hp4CZk
 HjjLzIUGxtqupEoz8LAqilaQK6ifkMTX+IPE4UQBA+F3a5Vnd2
 WkWypD1i7OUEwjfGJ5BSVJl90N6D+EOEF27zZRO8n60XszYe4I
 wNZUiDbVNoIwr6B5YnPo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 July 2014 18:01:51 Kweh Hock Leong wrote:
> From: "Chew, Chiau Ee" <chiau.ee.chew@intel.com>
> 
> Intel LPSS Baytrail supports two DMA controllers and SPI is only
> using one of the DMA controller. During DMA channel request,
> we need to ensure the requested Tx and Rx channels are from the correct
> DMA controller. Thus, we add extra checking in filter callback funtion
> by matching against the DMA controller device name.
> 
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>

I'm confused. Doesn't  Bay Trail use ACPI to do the DMA
engine configuration? That should set find the right device/chan_id/slave_id
combination without any interaction, through the use of dma_request_slave_channel.

On a related note, there seems to be a bug in this driver, which
attempts to set the slave_id through dmaengine_slave_config(), which
is wrong in both cases, ACPI and filter functions.

	Arnd
