Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbaAFVak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 16:30:40 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34822 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaAFVaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:30:39 -0500
Date: Mon, 06 Jan 2014 16:30:36 -0500 (EST)
Message-Id: <20140106.163036.1031013112322786.davem@davemloft.net>
To: dcbw@redhat.com
Cc: hns@goldelico.com, j.dumon@option.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marek.belisko@gmail.com, e.verdonck@option.com
Subject: Re: [PATCH] hso: fix handling of modem port SERIAL_STATE
 notifications
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389024449.1866.3.camel@dcbw.local>
References: <1387388963.5549.11.camel@dcbw.local>
	<874B65AE-8B15-4427-8EF4-F0CA2BC55062@goldelico.com>
	<1389024449.1866.3.camel@dcbw.local>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 13:30:39 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>
Date: Mon, 06 Jan 2014 10:07:29 -0600

> The existing serial state notification handling expected older Option
> devices, having a hardcoded assumption that the Modem port was always
> USB interface #2.  That isn't true for devices from the past few years.
> 
> hso_serial_state_notification is a local cache of a USB Communications
> Interface Class SERIAL_STATE notification from the device, and the
> USB CDC specification (section 6.3, table 67 "Class-Specific Notifications")
> defines wIndex as the USB interface the event applies to.  For hso
> devices this will always be the Modem port, as the Modem port is the
> only port which is set up to receive them by the driver.
> 
> So instead of always expecting USB interface #2, instead validate the
> notification with the actual USB interface number of the Modem port.
> 
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> Tested-by: H. Nikolaus Schaller <hns@goldelico.com>

Applied, although that BUG_ON() is a bit harsh.  It might have been
cleaner to just dev_warn() ratelimited or similar and return.
