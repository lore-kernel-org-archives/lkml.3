Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaJWNzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:55:05 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:42581 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaJWNzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:55:02 -0400
Date: Thu, 23 Oct 2014 15:54:12 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/14] net: dsa/mv88e6352: Implement EEPROM access
 functions
Message-ID: <20141023135412.GC25190@lunn.ch>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
 <1414037002-25528-11-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414037002-25528-11-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 09:03:18PM -0700, Guenter Roeck wrote:
> MV88E6352 supports read and write access to its configuration eeprom.

Hi Guenter

I don't have the datasheet for the MV88E6352. Is the EEPROM built in,
or external on an i2c bus?

> +static int mv88e6352_get_eeprom_len(struct dsa_switch *ds)
> +{
> +	return 0x200;
> +}

How do you handle the case of it being external and not populated.
Would it not be better to try to detect it here, and return 0 if it
does not exist?

      Andrew
