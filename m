Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbbALJYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 04:24:00 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35091 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbbALJX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 04:23:56 -0500
Message-ID: <54B392A7.2080702@ti.com>
Date: Mon, 12 Jan 2015 11:23:51 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <tony@atomide.com>
CC: <nm@ti.com>, <balbi@ti.com>, <george.cherian@ti.com>, <nsekhar@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] phy: ti-pipe3: Fix SATA across suspend/resume
References: <1418990720-3638-1-git-send-email-rogerq@ti.com> <1418990720-3638-3-git-send-email-rogerq@ti.com> <54AE6758.7030501@ti.com> <54AFDEB9.3060402@ti.com>
In-Reply-To: <54AFDEB9.3060402@ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 15:59, Kishon Vijay Abraham I wrote:
> Hi Roger,
> 
> On Thursday 08 January 2015 04:47 PM, Roger Quadros wrote:
>> Failed test case: Boot without SATA drive connected. Suspend/resume
>> the board and then connect SATA drive. It fails to enumerate.
>>
>> Due to Errata i783 "SATA Lockup After SATA DPLL Unlock/Relock"
>> we can't allow SATA DPLL to be in the unlocked state.
>> The SATA refclk (sata_ref_clk) is the source of the SATA_DPLL.
>> Till now this clock was controlled by the AHCI SATA driver and was being
>> shut off  during system suspend (if the SATA drive was not already attached)
>> causing the SATA DPLL to be unlocked and so causing errata i783.
>>
>> To prevent sata_ref_clk from being disabled, we move the control of
>> this clock from the SATA AHCI driver to the SATA PHY driver and prevent
>> it from being disabled.
>>
>> This also fixes the issue of SATA not working on OMAP5/DRA7 when
>> AHCI platform driver is built as a module.
> 
> I feel the dt patches and the PHY patches can go separately. Can you split and
> re-send?

OK. will re-send.

cheers,
-roger
