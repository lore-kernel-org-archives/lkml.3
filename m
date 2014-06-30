Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaF3Oh7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 10:37:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaF3Oh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 10:37:58 -0400
Date: Mon, 30 Jun 2014 07:37:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: donb@securitymouse.com, markus@oberhumer.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: lzo1x_decompress_safe: Macro compares unsigned to 0  (NO_EFFECT)
Message-ID: <20140630143745.GA22623@kroah.com>
References: <53b0f0f715b96_146f12c1338333fa@209.249.196.67.mail>
 <53B11047.3000105@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B11047.3000105@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 09:22:47AM +0200, Richard Weinberger wrote:
> This was introduced by:
> commit 206a81c18401c0cde6e579164f752c4b147324ce
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Fri Jun 20 22:00:53 2014 -0700
> 
>     lzo: properly check for overruns
> 
> Thanks,
> //richard
> 
> -------- Original-Nachricht --------
> Betreff: New Defects reported by Coverity Scan for Linux
> Datum: Sun, 29 Jun 2014 22:09:11 -0700
> Von: scan-admin@coverity.com
> 
> 
> Hi,
> 
> 
> Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.
> 
> Defect(s) Reported-by: Coverity Scan
> Showing 1 of 1 defect(s)
> 
> 
> ** CID 1224102:  Macro compares unsigned to 0  (NO_EFFECT)
> /lib/lzo/lzo1x_decompress_safe.c: 225 in lzo1x_decompress_safe()
> 
> 
> ________________________________________________________________________________________________________
> *** CID 1224102:  Macro compares unsigned to 0  (NO_EFFECT)
> /lib/lzo/lzo1x_decompress_safe.c: 225 in lzo1x_decompress_safe()
> 219     			op += t;
> 220     			ip += t;
> 221     		} else
> 222     #endif
> 223     		{
> 224     			NEED_IP(t, 3);
> >>>     CID 1224102:  Macro compares unsigned to 0  (NO_EFFECT)
> >>>     This greater-than-or-equal-to-zero comparison of an unsigned value is always true. "t + 0UL >= 0UL".
> 225     			NEED_OP(t, 0);
> 226     			while (t > 0) {
> 227     				*op++ = *ip++;
> 228     				t--;
> 229     			}
> 230     		}
> 
> 
> ________________________________________________________________________________________________________

Looks like coverity needs to fix their "this is how you test for an
overflow" logic, right?  Or did I get the test wrong?

thanks,

greg k-h
