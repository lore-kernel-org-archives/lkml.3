Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562AbaJHJCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:02:18 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:40643 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755186AbaJHJCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:02:13 -0400
Message-ID: <5434FD8F.8090209@nexus-software.ie>
Date: Wed, 08 Oct 2014 10:02:07 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Chen, Alvin" <alvin.chen@intel.com>, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Mark Brown <broonie@kernel.org>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Westerberg, Mika" <mika.westerberg@intel.com>,
        "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        "Tan, Raymond" <raymond.tan@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 2/2 v2] SPI: spi-pxa2xx: SPI support for Intel Quark X1000
References: <1412000548-9908-1-git-send-email-alvin.chen@intel.com> <1412000548-9908-3-git-send-email-alvin.chen@intel.com> <54348D56.20708@nexus-software.ie> <4656BEB6164FC34F8171C6538F1A595B2E997E59@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <4656BEB6164FC34F8171C6538F1A595B2E997E59@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/10/14 08:48, Chen, Alvin wrote:

> Now, we have another board which can support 4 slave spi per master, but not only Galileo. Since that board is not public, after discussing with team, we decide to make the
> upstream code to support '1'.
>
> I will change it back to
> .num_chipselect = 1,

Hi Alvin.

The important thing in terms of Galileo is to ensure that a GPIO can be 
used for chip-select.

The user-space API ported from Arduino to Linux wants to control it's 
own chip-select directly - so the internal chip-select of the Quark SPI 
master can - and does de-assert while doing SPI transactions on Galileo. 
The CS on the master is tied to FIFO occupancy - so at higher bit-rates 
we can fail to keep the FIFO occupied :(

That doesn't matter though, because the pinned out SPI:CS on the Arduino 
header is a GPIO.

 From the perspective of the Arduino code in user-space and the slave 
hardware @ the other end of the SPI bus - we see a nice and consistent 
chip-select for the entire duration of the SPI transaction - even though 
the actual SPI:CS coming from the SoC can *waggle* - when FIFOs go empty.

IMO - so long as you've tested on Galileo and seen working SPI - you're 
good to go anyway.

Bryan
