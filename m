Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755692Ab3HWRVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 13:21:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58790 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542Ab3HWRVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 13:21:03 -0400
Date: Fri, 23 Aug 2013 10:21:02 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] staging: lustre: Use proper constant types for
 L*_POISON values
Message-ID: <20130823172102.GA20400@kroah.com>
References: <1377272808-21686-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1377272808-21686-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 05:46:48PM +0200, Geert Uytterhoeven wrote:
> On 32-bit m68k, I get lots of warnings like:
> 
>     warning: integer constant is too large for ‘long’ type
> 
> Switch the L*_POISON definitions from too-large constants and casts
> to the proper constant types to fix this.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> The values in drivers/staging/lustre/lustre/include/linux/lustre_lib.h
> don't seem to be used, as LP_POISON is already defined at that point?

Probably.  I don't see where anyone even uses these "poison" values,
except to check variables to ensure they don't contain the value, which
is always going to be true as no one sets them.

Oh well, more dead code in the driver, nothing new...

thanks,

greg k-h
