Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3HERxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 13:53:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:38030 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3HERxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 13:53:16 -0400
Date: Mon, 5 Aug 2013 20:53:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rupesh Gujare <rupesh.gujare@atmel.com>
Cc: devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] staging: ozwpan: Increment port number for new
 device.
Message-ID: <20130805175302.GJ5051@mwanda>
References: <1375724415-10801-1-git-send-email-rupesh.gujare@atmel.com>
 <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375724415-10801-3-git-send-email-rupesh.gujare@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

This feels like papering over the problem.  Surely the real fix
would be to improve the reference counting.

This patch is probably effective but it makes the code more subtle
and it shows that we don't really understand what we are doing with
regards to reference counting.

regards,
dan carpenter

