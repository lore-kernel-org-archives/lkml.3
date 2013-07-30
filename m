Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338Ab3G3O3c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:29:32 -0400
Received: from mail-ve0-f182.google.com ([209.85.128.182]:40190 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754518Ab3G3O3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:29:30 -0400
MIME-Version: 1.0
In-Reply-To: <1375172936-4145-1-git-send-email-hayeswang@realtek.com>
References: <D7C722C73C7A400780358D0376412267@realtek.com.tw>
	<1375172936-4145-1-git-send-email-hayeswang@realtek.com>
Date: Tue, 30 Jul 2013 22:29:29 +0800
Message-ID: <CACVXFVOtVegwr6pzjwRsth1npw_iN6mB_YHaQ4Q7na4xVrY83g@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] net/usb/r815x: replace USB buffer from stack to DMA-able
From: Ming Lei <tom.leiming@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        nic_swsd@realtek.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 4:28 PM, Hayes Wang <hayeswang@realtek.com> wrote:
> Allocate the transfer buffer in probe(), and use the buffer for
> usb control transfer.

Looks this is a usbnet device, so suggest to use usbnet command APIs
(usbnet_read_cmd/usbnet_write_cmd) to do that, another advantage is
you can avoid to access runtime-suspended device from ethtool.


Thanks,
-- 
Ming Lei
