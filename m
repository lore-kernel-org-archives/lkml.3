Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab3LKBta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:49:30 -0500
Received: from mail-oa0-f54.google.com ([209.85.219.54]:37175 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LKBt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:49:26 -0500
Date: Tue, 10 Dec 2013 17:49:21 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 20/36] mtd: st_spi_fsm: Provide a method to put the
 chip into 32bit addressing mode
Message-ID: <20131211014921.GK27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-21-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-21-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:19:09PM +0000, Lee Jones wrote:
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -28,6 +28,8 @@
>  #include "st_spi_fsm.h"
>  #include "serial_flash_cmds.h"
>  
> +static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */

You need a space between the semicolon and the comment.

But why isn't this struct just embedded in the struct stfsm? I don't
like static instances like this, especially when they are dynamically
configured (as your comment notes). In the crazy even that we ever have
two of these FSMs on an SoC (can this happen?), you'll be introducing a
race on needlessly-shared data.

The same comment applies to your later structs stfsm_seq_read and
stfsm_seq_write.

Brian
