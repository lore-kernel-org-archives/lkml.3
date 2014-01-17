Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaAQJtZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 04:49:25 -0500
Received: from mx0.aculab.com ([213.249.233.131]:39296 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752131AbaAQJsZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 04:48:25 -0500
From: David Laight <David.Laight@ACULAB.COM>
To: "'Chen-Yu Tsai'" <wens@csie.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH RFC 1/6] net: rfkill: gpio: fix gpio name buffer size
 off by 1
Thread-Topic: [PATCH RFC 1/6] net: rfkill: gpio: fix gpio name buffer size
 off by 1
Thread-Index: AQHPE0+5GjqUl9o9BUy7yae5v6yQmpqIqomg
Date: Fri, 17 Jan 2014 09:46:08 +0000
Message-ID: <063D6719AE5E284EB5DD2968C1650D6D45EA9D@AcuExch.aculab.com>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
 <1389941251-32692-2-git-send-email-wens@csie.org>
In-Reply-To: <1389941251-32692-2-git-send-email-wens@csie.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.99.200]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen-Yu Tsai
> snprintf should be passed the complete size of the buffer, including
> the space for '\0'. The previous code resulted in the *_reset and
> *_shutdown strings being truncated.
...
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
...
> -	snprintf(rfkill->reset_name, len + 6 , "%s_reset", rfkill->name);
> -	snprintf(rfkill->shutdown_name, len + 9, "%s_shutdown", rfkill->name);
> +	snprintf(rfkill->reset_name, len + 7 , "%s_reset", rfkill->name);
> +	snprintf(rfkill->shutdown_name, len + 10, "%s_shutdown", rfkill->name);

I can't find the context for the above, but they look very dubious.
I'd expect: snprintf(foo, sizeof foo, ...).
If you are trying to truncate rfkill->name you need to use %.*s.

	David



