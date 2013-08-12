Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab3HLV56 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 17:57:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57266 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754866Ab3HLV55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 17:57:57 -0400
Date: Mon, 12 Aug 2013 14:57:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: ozwpan: Increment port number for new
 device.
Message-ID: <20130812215756.GA28233@kroah.com>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 06:40:13PM +0100, Rupesh Gujare wrote:
> This patch fixes crash issue when there is quick cycle of
> de-enumeration & enumeration due to loss of wireless link.
> 
> It is found that sometimes new device (or coming back device)
> returns very fast, even before USB core read out hub status,
> resulting in allocation of same port, which results in unstable
> system & crash.
> 
> Above issue is resolved by making sure that we always assign
> new port to new device, making sure that USB core reads correct
> hub status.
> 
> Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
> ---
>  drivers/staging/ozwpan/ozhcd.c |   16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)

No, don't paper over this, fix it correctly with reference counting as
Dan has suggested.

thanks,

greg k-h
