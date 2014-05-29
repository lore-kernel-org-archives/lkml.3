Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436AbaE2QH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:07:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40882 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaE2QHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:07:25 -0400
Date: Thu, 29 May 2014 09:11:01 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, devel@driverdev.osuosl.org,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH] Revert "staging: dgap: remove unneeded kfree() in
 dgap_tty_register_ports()"
Message-ID: <20140529161101.GA802@kroah.com>
References: <20140529070127.GA1347@devel.8.8.4.4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529070127.GA1347@devel.8.8.4.4>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 04:01:27PM +0900, Daeseok Youn wrote:
> This reverts commit 0ade4a34fd439d62df46937e8f3e584eb0879579.
> 
> This patch removes kfree for serial_ports in dgap_tty_register_ports()
> if the "brd->printer_ports" allocation fails and serial_ports may be
> freed by calling dgap_tty_uninit() within other patch.
> That patch has an error handling but incomplete cleanup
> so it need to call kfree() for brd->serial_ports in
> dgap_tty_register_ports().
> 
> Conflicts:
> 
> 	drivers/staging/dgap/dgap.c
> ---
>  drivers/staging/dgap/dgap.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)

-ENOSIGNEDOFFBY :(

