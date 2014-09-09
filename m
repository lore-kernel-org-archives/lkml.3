Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaIISnW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:43:22 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44188 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751356AbaIISnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:43:20 -0400
X-Sasl-enc: P+DPCi1Qq4w1v5QP4bcmTELUwrSoFGq27XugtcJCMncu 1410288199
Date: Tue, 9 Sep 2014 11:43:18 -0700
From: Greg KH <greg@kroah.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: "James E . J . Bottomley" <jejb@parisc-linux.org>,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/3] parisc/uapi: Add definition of TIOC[SG]RS485
Message-ID: <20140909184318.GA6231@kroah.com>
References: <1410285991-24833-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410285991-24833-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:06:31PM +0200, Ricardo Ribalda Delgado wrote:
> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 (serial/8250: Add
> support for RS485 IOCTLs), adds support for RS485 ioctls for 825_core on
> all the archs. Unfortunaltely the definition of TIOCSRS485 and
> TIOCGRS485 was missing on the ioctls.h file
> 
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  arch/parisc/include/uapi/asm/ioctls.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/parisc/include/uapi/asm/ioctls.h b/arch/parisc/include/uapi/asm/ioctls.h
> index 66719c3..3af2d02 100644
> --- a/arch/parisc/include/uapi/asm/ioctls.h
> +++ b/arch/parisc/include/uapi/asm/ioctls.h
> @@ -50,6 +50,8 @@
>  #define TCSETS2		_IOW('T',0x2B, struct termios2)
>  #define TCSETSW2	_IOW('T',0x2C, struct termios2)
>  #define TCSETSF2	_IOW('T',0x2D, struct termios2)
> +#define TIOCGRS485	0x542E
> +#define TIOCSRS485	0x542F

As David pointed out with the sparc patch, please use the proper ioctl
macros for these numbers.

Please redo all of these patches and resend.

thanks,

greg k-h
