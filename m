Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795AbaIER5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 13:57:39 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:64890 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaIER5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 13:57:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND v5 1/5] usb: host: ehci-st: Add EHCI support for ST STB devices
Date: Fri, 05 Sep 2014 19:57:28 +0200
Message-ID: <202755915.brE74x99uQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1409937829-23708-2-git-send-email-peter.griffin@linaro.org>
References: <1409937829-23708-1-git-send-email-peter.griffin@linaro.org> <1409937829-23708-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:aFknGXGZD/cKX2ZHB0XUcN+oZMhqvBd/m+y6ndOkB6z
 vplsYekjEB2cA1+PVm3cBYqFZD24ZKefbmc5nvjbdaDOIxVJlY
 guNrEyR3tavgZyNixopLv+nIUgqf/ppIKMBiaI5NCB0pbubw2Q
 XkCWszw48OFgWfIpN6+0/7EQupvrD9jfs+q+t5IxVuBItPEBeA
 8ls70zAmkV5yG5G1FvpvCiQkhzmUK49IK10oN5GmOU214YdyI+
 awZfh62Jpadn9lN0erO4nmQ+Oqt0BQG00UWHwLLj5kax64nGyt
 P5f4JkeAOENYsnOJlgjeSrCTzb5q0xifS0UM3+G3DGU1ckEQXS
 7lMfVCJulq/uCTZrzYpY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 September 2014 18:23:45 Peter Griffin wrote:
> +struct st_platform_priv {
> +       struct clk *clks[USB_MAX_CLKS];
> +       struct clk *clk48;
> +       struct reset_control *rst;
> +       struct reset_control *pwr;
> +       struct phy *phy;
> +};

Any reason why this is in a shared header file? It looks like
duplicating the structure under two different names would
actually be shorter and keep the drivers more readable as they'd
be self-contained, even when they have the exact same structure.

Do both drivers use all fields?

	Arnd
