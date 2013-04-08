Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936170Ab3DHKDC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 06:03:02 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:57386 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936149Ab3DHKC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 06:02:58 -0400
Date: Mon, 8 Apr 2013 12:01:57 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com, Johan Hovold <jhovold@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 035/102] USB: serial: add modem-status-change wait queue
Message-ID: <20130408100157.GD25605@localhost>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
 <1365414657-29191-36-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365414657-29191-36-git-send-email-luis.henriques@canonical.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 10:49:50AM +0100, Luis Henriques wrote:
> 3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Johan Hovold <jhovold@gmail.com>
> 
> commit e5b33dc9d16053c2ae4c2c669cf008829530364b upstream.
> 
> Add modem-status-change wait queue to struct usb_serial_port that
> subdrivers can use to implement TIOCMIWAIT.
> 
> Currently subdrivers use a private wait queue which may have been
> released when waking up after device disconnected.
> 
> Note that we're adding a new wait queue rather than reusing the tty-port
> one as we do not want to get woken up at hangup (yet).

This one should be followed by eba0e3c3a0ba7b96f0 (USB: serial: fix hang
when opening port) which adds the missing queue initialisation. It
appears the next patch in your series starts using the wait queue
directly.

Thanks,
Johan

> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
> ---
>  include/linux/usb/serial.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/linux/usb/serial.h b/include/linux/usb/serial.h
> index 86c0b45..0b61f01 100644
> --- a/include/linux/usb/serial.h
> +++ b/include/linux/usb/serial.h
> @@ -66,6 +66,7 @@
>   *	port.
>   * @flags: usb serial port flags
>   * @write_wait: a wait_queue_head_t used by the port.
> + * @delta_msr_wait: modem-status-change wait queue
>   * @work: work queue entry for the line discipline waking up.
>   * @throttled: nonzero if the read urb is inactive to throttle the device
>   * @throttle_req: nonzero if the tty wants to throttle us
> @@ -112,6 +113,7 @@ struct usb_serial_port {
>  
>  	unsigned long		flags;
>  	wait_queue_head_t	write_wait;
> +	wait_queue_head_t	delta_msr_wait;
>  	struct work_struct	work;
>  	char			throttled;
>  	char			throttle_req;
