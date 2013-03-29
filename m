Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab3C2Qe2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 12:34:28 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:34486 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713Ab3C2Qe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 12:34:27 -0400
Date: Fri, 29 Mar 2013 09:34:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [rtmutex-tester] WARNING: at drivers/base/core.c:569
 device_create_file()
Message-ID: <20130329163424.GA3380@kroah.com>
References: <20130329021704.GA9457@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130329021704.GA9457@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 10:17:04AM +0800, Fengguang Wu wrote:
> Hi Kay,
> 
> I got the below warning and the first "bad" commit is
> 
> commit 8f46baaa7ec6cd0851794020b31958e64679dd26
> Author: Felipe Balbi <balbi@ti.com>
> Date:   Wed Feb 20 10:31:42 2013 +0200
> 
>     base: core: WARN() about bogus permissions on device attributes
>     
>     Whenever a struct device_attribute is registered
>     with mismatched permissions - read permission without
>     a show routine or write permission without store
>     routine - we will issue a big warning so we catch
>     those early enough.
>     
>     Signed-off-by: Felipe Balbi <balbi@ti.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

That's just a "warning" patch, I'll fix this up properly
(kernel/rtmutex-tester.c has 0600 as the mode for a read-only attribute
as well as a write-only attribute.)

thanks,

greg k-h
