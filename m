Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757730AbaHGOrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 10:47:18 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61539 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757516AbaHGOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 10:47:15 -0400
Date: Thu, 7 Aug 2014 15:47:10 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v3 0/6] Add EHCI and OHCI drivers for STi SoC's
Message-ID: <20140807144710.GD12137@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1407344589-24863-1-git-send-email-peter.griffin@linaro.org>
 <201408062318.28958.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201408062318.28958.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing, see my comments below: -

> > Changes since v2:
> >  - Based on Arnd Berghman feedback, split out into 2 devices / drivers
> >  - Base drivers oh ehci-platform.c & ohci-platform.c with required extensions
> >    to allow possible re-merge in the furture.
> 
> Hi Peter,
> 
> This looks much better than the first version. I have some remaining comments for
> how it could be simplified a bit more.

Yes I think I've addressed these now in V4, which I will send in a moment.

> 
> The way that you deal with the 48mhz clock seems like it should fit in well
> with the generic driver, just like all the rest (once the usb-st-common
> stuff is moved into the ohci/ehci drivers), so the alternative would be
> to make it all generic now.

Yes I tried to do it in a way which would, however I would prefer not to merge into 
the generic one for now because: -

1) There are some other subtle changes versus the generic drivers. For example in power_on() and power_off()
I put the IP into reset and power down, which isn't done in the generic driver. Also with this IP it needs 
power signal asserted before reset, otherwise it can hang the chip.

2) I don't have any of the other hardware which uses ehci-platform / ohci-platform to test 
I haven't broken things.

regards,

Peter.



