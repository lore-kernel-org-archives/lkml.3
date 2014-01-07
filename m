Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087AbaAGQLq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 11:11:46 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33969 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaAGQLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 11:11:41 -0500
Date: Tue, 7 Jan 2014 16:11:36 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Angus Clark <angus.clark@st.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 09/36] mtd: st_spi_fsm: Provide device look-up table
Message-ID: <20140107161136.GK3182@lee--X1>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-10-git-send-email-lee.jones@linaro.org>
 <20131210220338.GF27149@ld-irv-0074.broadcom.com>
 <52B016A0.3080201@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52B016A0.3080201@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >> +/* SPI Flash Device Table */
> >> +struct flash_info {
> >> +	char		*name;
> >> +	/*
> >> +	 * JEDEC id zero means "no ID" (most older chips); otherwise it has
> >> +	 * a high byte of zero plus three data bytes: the manufacturer id,
> >> +	 * then a two byte device id.
> >> +	 */
> >> +	u32		jedec_id;
> >> +	u16             ext_id;
> > 
> > Will 5 bytes of ID be enough? I think we're running into a need for 6
> > bytes of ID in m25p80.c right about now. Might make sense to start with
> > the right number of bytes.
> 
> Yes, we will need 6 bytes of ID.  The "dirty" stm_spi_fsm driver already handles
> arbitrary-length IDs.  This will need to be pulled into the "upstream" version
> at some point.

Just looking at this now. May I do this subsequently? It's a pretty
big change and I don't want to disturb the patch-set too much at this
moment. The "dirty" kernel has only been updated with this change
recently. We will need it too, but we can definitely do without it for
a little while.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
