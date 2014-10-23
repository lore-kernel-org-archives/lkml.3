Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbaJWNsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 09:48:00 -0400
Received: from vps0.lunn.ch ([178.209.37.122]:42569 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaJWNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 09:47:58 -0400
Date: Thu, 23 Oct 2014 15:47:06 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Florian Fainelli <f.fainelli@gmail.com>, netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Andrew Lunn <andrew@lunn.ch>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/14] net: dsa: Add support for hardware monitoring
Message-ID: <20141023134706.GB25190@lunn.ch>
References: <1414037002-25528-1-git-send-email-linux@roeck-us.net>
 <1414037002-25528-7-git-send-email-linux@roeck-us.net>
 <CAGVrzcYjPJWai9bxkh+WRrEEAzBKBd-LQm7zDeeouxngr_v9SQ@mail.gmail.com>
 <54488CE1.2000106@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54488CE1.2000106@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>+static DEVICE_ATTR_RO(temp1_input);
> >
> >You probably want the number of temperature sensors to come from the
> >switch driver, and support arbitrary number of temperature sensors?
> 
> In that case we would need the number of sensors, pass a sensor index,
> and create a dynamic number of attributes. The code would get much more
> complex without real benefit unless there is such a chip 

We are two different use cases here:

One switch chip with multiple temperature sensors
Multiple switch chips, each with its own temperature sensor.

I don't know of any hardware using either of these uses cases, but
they could appear in the future.

If we are not doing the generic implementation now, how about avoiding
an ABI break in the future, by hard coding the sensors with .0.0 on
the end?

    Andrew
