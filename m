Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3BRRq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:46:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47699 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3BRRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:46:24 -0500
Date: Mon, 18 Feb 2013 12:46:22 -0500 (EST)
Message-Id: <20130218.124622.1089178393000360367.davem@davemloft.net>
To: mchan@broadcom.com
Cc: joe@perches.com, mcarlson@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tg3: Use different macros for pci_chip_rev_id
 accesses
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361052585.2240.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <dea1c655b2c1380821aae6cd8438ad742ddf6e12.1361049158.git.joe@perches.com>
	<1d3ed7a644e8de210614f51375e8e913da2f5cb3.1361049158.git.joe@perches.com>
	<1361052585.2240.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael Chan" <mchan@broadcom.com>
Date: Sat, 16 Feb 2013 14:09:45 -0800

> On Sat, 2013-02-16 at 13:20 -0800, Joe Perches wrote:
>> Upper case macros for various chip attributes are slightly
>> difficult to read and are a bit out of characterto the other
>> tg3_<foo> attribute functions.
>> 
>> Convert:
>> 
>> GET_ASIC_REV(tp->pci_chip_rev_id)       -> tg3_asic_rev(tp)
>> GET_CHIP_REV(tp->pci_chip_rev_id)       -> tg3_chip_rev(tp)
>> 
>> Remove:
>> GET_METAL_REV(tp->pci_chip_rev_id)      -> tg3_metal_rev(tp) (unused)
>> 
>> Add:
>> tg3_chip_rev_id(tp) for tp->pci_chip_rev_id so access styles
>> are similar to tg3_asic_rev and tg3_chip_rev.
>> 
>> These macros are not converted to static inline functions
>> because gcc (tested with 4.7.2) is currently unable to
>> optimize the object code it produces the same way and code
>> is otherwise larger.
>> 
>> Signed-off-by: Joe Perches <joe@perches.com> 
> 
> Acked-by: Michael Chan <mchan@broadcom.com>

Applied.
