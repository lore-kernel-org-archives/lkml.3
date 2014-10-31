Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424AbaJaUNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 16:13:10 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:43239 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757236AbaJaUNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 16:13:08 -0400
Date: Fri, 31 Oct 2014 16:13:06 -0400 (EDT)
Message-Id: <20141031.161306.1209095823862991107.davem@davemloft.net>
To: andrew@lunn.ch
Cc: linux@roeck-us.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethtool: Return -EOPNOTSUPP if user space tries
 to read EEPROM with lengh 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141031035635.GC4082@lunn.ch>
References: <1414727415-5470-1-git-send-email-linux@roeck-us.net>
	<20141031035635.GC4082@lunn.ch>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 31 Oct 2014 13:13:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Fri, 31 Oct 2014 04:56:35 +0100

> On Thu, Oct 30, 2014 at 08:50:15PM -0700, Guenter Roeck wrote:
>> If a driver supports reading EEPROM but no EEPROM is installed in the system,
>> the driver's get_eeprom_len function returns 0. ethtool will subsequently
>> try to read that zero-length EEPROM anyway. If the driver does not support
>> EEPROM access at all, this operation will return -EOPNOTSUPP. If the driver
>> does support EEPROM access but no EEPROM is installed, the operation will
>> return -EINVAL. Return -EOPNOTSUPP in both cases for consistency.
>> 
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> root@dir665:~# ethtool -e lan4
> Cannot get EEPROM data: Operation not supported
> 
> Tested-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks everyone.
