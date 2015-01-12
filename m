Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444AbbALMuF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 07:50:05 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:47663 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbbALMuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 07:50:03 -0500
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Jan 2015 07:50:02 EST
Message-ID: <1421066230.12454.24.camel@linux-0dmf.site>
Subject: Re: [PATCH] usb/kaweth: use GFP_ATOMIC under spin_lock in
 usb_start_wait_urb()
From: Oliver Neukum <oliver@neukum.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "David S. Miller" <davem@davemloft.net>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Date: Mon, 12 Jan 2015 13:37:10 +0100
In-Reply-To: <1420845382-25815-1-git-send-email-khoroshilov@ispras.ru>
References: <1420845382-25815-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-10 at 02:16 +0300, Alexey Khoroshilov wrote:
> Commit e4c7f259c5be ("USB: kaweth.c: use GFP_ATOMIC under spin_lock")
> makes sure that kaweth_internal_control_msg() allocates memory with
> GFP_ATOMIC,
> but kaweth_internal_control_msg() also calls usb_start_wait_urb()
> that still allocates memory with GFP_NOIO.
> 
> The patch fixes usb_start_wait_urb() as well.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Acked-by: Oliver Neukum <oliver@neukum.org>

