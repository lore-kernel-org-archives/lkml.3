Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaHKNdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:33:04 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:54934 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaHKNdB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:33:01 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "Fabio Estevam (festevam@gmail.com)" <festevam@gmail.com>
CC: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHui4wD//8wREAAM+aMA//6IPID//QHtAP/4Df8A/+ub5xA=
Date: Mon, 11 Aug 2014 13:32:57 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB8043576356@ALVA-EXMB04.alv.autoliv.int>
References: <20140626151424.GT32514@n2100.arm.linux.org.uk>
 <20140627112151.GF32514@n2100.arm.linux.org.uk>
 <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
 <20140627163108.GP32514@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
 <20140806095012.GN30282@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
 <20140806125550.GO30282@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB804357526C@ALVA-EXMB04.alv.autoliv.int>
 <20140807121248.GY30282@n2100.arm.linux.org.uk>
 <20140808180900.GG30282@n2100.arm.linux.org.uk>
In-Reply-To: <20140808180900.GG30282@n2100.arm.linux.org.uk>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.137]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1018-20872.005
x-tm-as-result: No--26.847900-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell and Fabio,

> I'd be interested to hear whether removing the
> 
> 	interrupts-extended = ...
> 
> property from your board's DT file, thereby causing you to revert back to the
> default I list above, also fixes the instability you are seeing.

We have tried to remove the board specific interrupts-extended field and the
MX6QDL_PAD_GPIO_6__ENET_IRQ entry. Sadly this did not seem to improve
the stalls. Our interrupts look like this now:

150:      15519          0          0          0       GIC 150  2188000.ethernet
151:          0          0          0          0       GIC 151  2188000.ethernet

Our device tree might still be slightly incorrect. We have noticed that our
RGMII_INT is connected to GPIO 19 (P5) which might be nonstandard (we are
a bit surprised that this works at all). We are not quite sure how to configure
this properly.

Best regards,
Mattis Lorentzon
***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

