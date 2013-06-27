Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753571Ab3F0Rqy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 13:46:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35743 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708Ab3F0Rqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 13:46:53 -0400
Date: Thu, 27 Jun 2013 10:46:51 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "David 'Digit' Turner" <digit@android.com>,
        Xiaohui Xin <xiaohui.xin@intel.com>,
        Yunhong Jiang <yunhong.jiang@intel.com>,
        Jun Nakajima <jun.nakajima@intel.com>,
        Tom Keel <thomas.keel@intel.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: goldfish driver: Missing get_user_pages in
 goldfish_pipe_read_write()
Message-ID: <20130627174651.GA19874@kroah.com>
References: <20130627173532.GA29405@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130627173532.GA29405@Krystal>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 27, 2013 at 01:35:32PM -0400, Mathieu Desnoyers wrote:
> The following code snippet:
> 
> drivers/platform/goldfish/goldfish_pipe.c:
> goldfish_pipe_read_write()
> 
>                 /* Ensure that the corresponding page is properly mapped */
>                 /* FIXME: this isn't safe or sufficient - use get_user_pages */
>                 if (is_write) {
>                         char c;
>                         /* Ensure that the page is mapped and readable */
>                         if (__get_user(c, (char __user *)address)) {
>                                 if (!ret)
>                                         ret = -EFAULT;
>                                 break;
>                         }
>                 } else {
>                         /* Ensure that the page is mapped and writable */
>                         if (__put_user(0, (char __user *)address)) {
>                                 if (!ret)
>                                         ret = -EFAULT;
>                                 break;
>                         }
>                 }
> 
> Seems to lack the kind of validation required to make it fail properly
> if the memory range is not fully populated.

This is an emulated platform only, so it's probably not a big deal,
right?

> I see that this feature has been merged in Linux kernel 3.9, but the
> FIXME is still there in 3.10-rc7. Any plans on fixing this ?

It would be good to get fixed, but probably way down on the priority
list.

thanks,

greg k-h
