Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab3ARTXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 14:23:19 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38645 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754153Ab3ARTXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 14:23:17 -0500
Date: Fri, 18 Jan 2013 14:23:16 -0500 (EST)
Message-Id: <20130118.142316.708739494707619536.davem@davemloft.net>
To: freddy@asix.com.tw
Cc: netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, louis@asix.com.tw
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0
 to gigabit ethernet adapter driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358415174-4348-1-git-send-email-freddy@asix.com.tw>
References: <1358415174-4348-1-git-send-email-freddy@asix.com.tw>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Freddy Xin <freddy@asix.com.tw>
Date: Thu, 17 Jan 2013 17:32:54 +0800

> +struct ax88179_rx_pkt_header {
> +
> +	u8	l4_csum_err:1,

Get rid of such extraneous empty lines.  They do not add clarity,
rather they just take up space.

> +	ret = fn(dev, cmd, USB_DIR_IN | USB_TYPE_VENDOR |
> +			USB_RECIP_DEVICE, value, index, data, size);

This is not indented properly.  When a function call takes up
multiple lines, the text on the second and subsequent lines must
be left justified to the first column after the openning parenthesis
of the function call, like this:

	function(arg1, arg2,
		 arg3, arg4);

You must use the appropriate combination of TAB and space characters
to achieve this.  If you are trying to only use TAB characters, you
are doing it wrong.

This code has a lot of other similar coding style errors, please
put some effort into fixing them up before you consider resubmitting
this driver.

All of the coding style errors are probably why nobody reviewed your
driver the first time around, there's already enough properly styled
submissions to review.
