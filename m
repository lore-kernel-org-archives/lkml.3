Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbaBDR5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 12:57:42 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:63734 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbaBDR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 12:57:40 -0500
Message-ID: <52F12A10.3020600@lwfinger.net>
Date: Tue, 04 Feb 2014 11:57:36 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: andrea.merello@gmail.com, Dan Carpenter <dan.carpenter@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Subject: Re: rtl8821ae.
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail> <20140202160512.GA4946@redhat.com> <201402021807.37772.s.L-H@gmx.de> <52EFCC66.9020304@lwfinger.net> <20140203201228.GE26722@mwanda> <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com> <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com> <20140204092836.GG26776@mwanda> <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
In-Reply-To: <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea,

After applying the latest patch, I get the following warning and errors when 
building the USB driver rtl8187:

   CC      drivers/video/fbmon.o
drivers/net/wireless/rtl818x/rtl8187/dev.c: In function ‘rtl8187_set_anaparam’:
drivers/net/wireless/rtl818x/rtl8187/dev.c:595:3: warning: passing argument 2 of 
‘rtl818x_iowrite8’ from incompatible pointer type [enabled by default]
    rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, anaparam3);
    ^
In file included from drivers/net/wireless/rtl818x/rtl8187/dev.c:31:0:
drivers/net/wireless/rtl818x/rtl8187/rtl8187.h:237:20: note: expected ‘u8 *’ but 
argument is of type ‘__le16 *’
  static inline void rtl818x_iowrite8(struct rtl8187_priv *priv, u8 *addr, u8 val)
                     ^
drivers/net/wireless/rtl818x/rtl8187/dev.c: In function ‘rtl8187b_init_hw’:
drivers/net/wireless/rtl818x/rtl8187/dev.c:788:9: error: 
‘RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT’ undeclared (first use in this function)
   reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
          ^
drivers/net/wireless/rtl818x/rtl8187/dev.c:788:9: note: each undeclared 
identifier is reported only once for each function it appears in
drivers/net/wireless/rtl818x/rtl8187/dev.c: In function ‘rtl8187_start’: 

drivers/net/wireless/rtl818x/rtl8187/dev.c:946:11: error: 
‘RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT’ undeclared (first use in this 
function)
    reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT; 

            ^
drivers/net/wireless/rtl818x/rtl8187/dev.c:947:11: error: 
‘RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT’ undeclared (first use in this function)
    reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
            ^
drivers/net/wireless/rtl818x/rtl8187/dev.c:952:7: error: 
‘RTL818X_TX_CONF_HW_SEQNUM’ undeclared (first use in this function)
        RTL818X_TX_CONF_HW_SEQNUM |
        ^
drivers/net/wireless/rtl818x/rtl8187/dev.c:989:10: error: 
‘RTL818X_CW_CONF_PERPACKET_CW_SHIFT’ undeclared (first use in this function)
   reg &= ~RTL818X_CW_CONF_PERPACKET_CW_SHIFT;
           ^
drivers/net/wireless/rtl818x/rtl8187/dev.c:990:9: error: 
‘RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT’ undeclared (first use in this function)
   reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;

The warning is fixed by

Index: wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/rtl818x/rtl8187/dev.c
+++ wireless-testing/drivers/net/wireless/rtl818x/rtl8187/dev.c
@@ -593,7 +593,7 @@ static void rtl8187_set_anaparam(struct
         rtl818x_iowrite32(priv, &priv->map->ANAPARAM, anaparam);
         rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, anaparam2);
         if (priv->is_rtl8187b)
-               rtl818x_iowrite8(priv, &priv->map->ANAPARAM3, anaparam3);
+               rtl818x_iowrite16(priv, &priv->map->ANAPARAM3, anaparam3);
         reg &= ~RTL818X_CONFIG3_ANAPARAM_WRITE;
         rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
         rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,

For testing purposes, I have turned on the build for rtl8187.

Larry

