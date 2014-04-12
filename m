Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014AbaDLSjG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 14:39:06 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:41310 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaDLSjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 14:39:04 -0400
Message-ID: <1397327940.4810.4.camel@linux-fkkt.site>
Subject: Re: [PATCH] USB: cdc-acm: fix double usb_autopm_put_interface() in
 acm_port_activate()
From: Oliver Neukum <oliver@neukum.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Date: Sat, 12 Apr 2014 20:39:00 +0200
In-Reply-To: <1397254245-7498-1-git-send-email-khoroshilov@ispras.ru>
References: <1397254245-7498-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-04-12 at 02:10 +0400, Alexey Khoroshilov wrote:
> If acm_submit_read_urbs() fails in acm_port_activate(), error handling
> code calls usb_autopm_put_interface() while it is already called
> before acm_submit_read_urbs(). The patch reorganizes error handling code
> to avoid double decrement of USB interface's PM-usage counter.
> 
> Found by Linux Driver Verification project (linuxtesting.org).

Nice catch.

> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Oliver Neukum <oliver@neukum.org>


