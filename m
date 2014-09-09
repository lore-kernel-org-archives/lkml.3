Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaIITS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:18:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45361 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439AbaIITSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:18:24 -0400
Date: Tue, 9 Sep 2014 12:18:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Chris Zankel <chris@zankel.net>,
        "Max Filippov linux-xtensa @ linux-xtensa . org" <jcmvbkbc@gmail.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 2/2] xtensa/uapi: Add definition of TIOC[SG]RS485
Message-ID: <20140909191824.GB7467@kroah.com>
References: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410240056-22786-1-git-send-email-ricardo.ribalda@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 07:20:56AM +0200, Ricardo Ribalda Delgado wrote:
> Commit: e676253b19b2d269cccf67fdb1592120a0cd0676 [3/21] serial/8250: Add
> support for RS485 IOCTLs, adds support for RS485 ioctls for 825_core on
> all the archs. Unfortunaltely the definition of TIOCSRS485 and
> TIOCGRS485 was missing on the ioctls.h file
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  arch/xtensa/include/uapi/asm/ioctls.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/xtensa/include/uapi/asm/ioctls.h b/arch/xtensa/include/uapi/asm/ioctls.h
> index a47909f..accda82 100644
> --- a/arch/xtensa/include/uapi/asm/ioctls.h
> +++ b/arch/xtensa/include/uapi/asm/ioctls.h
> @@ -95,6 +95,8 @@
>  #define TCSETS2		_IOW('T', 43, struct termios2)
>  #define TCSETSW2	_IOW('T', 44, struct termios2)
>  #define TCSETSF2	_IOW('T', 45, struct termios2)
> +#define TIOCGRS485	0x542E
> +#define TIOCSRS485	0x542F

Like your patches for other arches, please use a _IOW() macro here, not a "number".

thanks,

greg k-h
