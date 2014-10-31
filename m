Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933997AbaJaD5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 23:57:40 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:46667 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbaJaD5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 23:57:39 -0400
Date: Fri, 31 Oct 2014 04:56:35 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethtool: Return -EOPNOTSUPP if user space tries to
 read EEPROM with lengh 0
Message-ID: <20141031035635.GC4082@lunn.ch>
References: <1414727415-5470-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414727415-5470-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 08:50:15PM -0700, Guenter Roeck wrote:
> If a driver supports reading EEPROM but no EEPROM is installed in the system,
> the driver's get_eeprom_len function returns 0. ethtool will subsequently
> try to read that zero-length EEPROM anyway. If the driver does not support
> EEPROM access at all, this operation will return -EOPNOTSUPP. If the driver
> does support EEPROM access but no EEPROM is installed, the operation will
> return -EINVAL. Return -EOPNOTSUPP in both cases for consistency.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

root@dir665:~# ethtool -e lan4
Cannot get EEPROM data: Operation not supported

Tested-by: Andrew Lunn <andrew@lunn.ch>

Thanks
	Andrew
