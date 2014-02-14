Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676AbaBNUs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 15:48:57 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:37800 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaBNUs4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 15:48:56 -0500
Date: Fri, 14 Feb 2014 15:48:53 -0500 (EST)
Message-Id: <20140214.154853.1291869116525546930.davem@davemloft.net>
To: emilgoode@gmail.com
Cc: ming.lei@canonical.com, broonie@linaro.org, jeffrey.t.kirsher@intel.com,
        gdt@gdt.id.au, linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH Resend] net: asix: add missing flag to struct
 driver_info
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392316239-17335-1-git-send-email-emilgoode@gmail.com>
References: <1392316239-17335-1-git-send-email-emilgoode@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 14 Feb 2014 12:48:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emil Goode <emilgoode@gmail.com>
Date: Thu, 13 Feb 2014 19:30:39 +0100

> The struct driver_info ax88178_info is assigned the function
> asix_rx_fixup_common as it's rx_fixup callback. This means that
> FLAG_MULTI_PACKET must be set as this function is cloning the
> data and calling usbnet_skb_return. Not setting this flag leads
> to usbnet_skb_return beeing called a second time from within
> the rx_process function in the usbnet module.
> 
> Signed-off-by: Emil Goode <emilgoode@gmail.com>
> Reported-by: Bjørn Mork <bjorn@mork.no>

Applied and queued up for -stable.

It would be great if there were some way to validate these
callback flags requirements and catch such errors.
