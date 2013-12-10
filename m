Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751170Ab3LJUIQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:08:16 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:48321 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab3LJUIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:08:15 -0500
Date: Tue, 10 Dec 2013 12:08:10 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 03/36] mtd: st_spi_fsm: Initialise and configure the
 FSM for normal working conditions
Message-ID: <20131210200810.GB27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-4-git-send-email-lee.jones@linaro.org>
 <20131210190100.GA27149@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131210190100.GA27149@ld-irv-0074.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 10, 2013 at 11:01:00AM -0800, Brian Norris wrote:
> On Fri, Nov 29, 2013 at 12:18:52PM +0000, Lee Jones wrote:
> > +	/*
> > +	 * Calculate clk_div - values between 2 and 128
> > +	 * Multiple of 2, rounded up
> > +	 */
> > +	clk_div = 2*((emi_freq + (2*spi_freq - 1))/(2*spi_freq));
> 
> I think this can use the <linux/kerne.h> round_up() macro. Also, you're
> missing some spacing. Possibly:
> 
> 	clk_div = 2 * round_up(emi_freq, 2 * spi_freq);

Sorry, I was reading one thing and writing another; this would be
DIV_ROUND_UP():

	clk_div = 2 * DIV_ROUND_UP(emi_freq, 2 * spi_freq);

> > +		fsm->fifo_dir_delay = (clk_div + 9) / 10;
> 
> round_down()?

Sorry, I again meant DIV_ROUND_UP:

		fsm->fifo_dir_delay = DIV_ROUND_UP(clk_div, 10);

Brian
