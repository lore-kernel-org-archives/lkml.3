Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaIESQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 14:16:43 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:61700 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaIESQl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 14:16:41 -0400
Date: Fri, 5 Sep 2014 19:16:36 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stern@rowland.harvard.edu, gregkh@linuxfoundation.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH RESEND v5 1/5] usb: host: ehci-st: Add EHCI support for
 ST STB devices
Message-ID: <20140905181636.GA1715@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1409937829-23708-1-git-send-email-peter.griffin@linaro.org>
 <1409937829-23708-2-git-send-email-peter.griffin@linaro.org>
 <202755915.brE74x99uQ@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202755915.brE74x99uQ@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Fri, 05 Sep 2014, Arnd Bergmann wrote:

> On Friday 05 September 2014 18:23:45 Peter Griffin wrote:
> > +struct st_platform_priv {
> > +       struct clk *clks[USB_MAX_CLKS];
> > +       struct clk *clk48;
> > +       struct reset_control *rst;
> > +       struct reset_control *pwr;
> > +       struct phy *phy;
> > +};
> 
> Any reason why this is in a shared header file? It looks like
> duplicating the structure under two different names would
> actually be shorter and keep the drivers more readable as they'd
> be self-contained, even when they have the exact same structure.

The only reason was it was a identical structure so I put it in a shared
header file. I can unabstract it if you want?

> 
> Do both drivers use all fields?

Yes they are. I thought the 48Mhz clock would only be used by ohci, but annoyingly it also
clocks the reset logic of the ehci block as well.

regards,

Peter.
