Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753943AbaFDOWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 10:22:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33621 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207AbaFDOWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 10:22:37 -0400
Date: Wed, 4 Jun 2014 07:22:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valerio Vanni <valerio.vanni@inwind.it>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/2] serial: core: Preserve termios c_cflag for console
 resume
Message-ID: <20140604142232.GB1008@kroah.com>
References: <7EC4C3FDEFF6492F91DEE16AEE0831E6@vanni.it>
 <1401891371-4946-1-git-send-email-peter@hurleysoftware.com>
 <1401891371-4946-2-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401891371-4946-2-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 04, 2014 at 10:16:11AM -0400, Peter Hurley wrote:
> When a tty is opened for the serial console, the termios c_cflag
> settings are inherited from the console line settings.
> However, if the tty is subsequently closed, the termios settings
> are lost. This results in a garbled console if the console is later
> suspended and resumed.
> 
> Preserve the termios c_cflag for the serial console when the tty
> is shutdown; this reflects the most recent line settings.
> 
> Fixes: Bugzilla #69751, 'serial console does not wake from S3'
> Reported-by: Valerio Vanni <valerio.vanni@inwind.it>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/serial/serial_core.c | 3 +++
>  1 file changed, 3 insertions(+)

Same as before, regression, or just a normal "new feature"?

greg k-h
