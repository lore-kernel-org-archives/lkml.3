Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489Ab3KYObP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:31:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46118 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167Ab3KYObM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:31:12 -0500
Date: Mon, 25 Nov 2013 06:31:54 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: 3.12.1 Virt dev invalid for slot_id 0x1
Message-ID: <20131125143154.GA4003@kroah.com>
References: <528E975B.5010200@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528E975B.5010200@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 04:29:31PM -0700, Shuah Khan wrote:
> I started seeing the following on my Samsung Series on 3.12.1
> 
> Is this bad? Looks like the following WARN_ON is firing:
> 
> drivers/usb/host/xhci.c:
> 
>          if (WARN_ON(!virt_dev)) {
>                  /*
>                   * In plug/unplug torture test with an NEC controller,
>                   * a zero-dereference was observed once due to virt_dev 
> = 0.
>                   * Print useful debug rather than crash if it is 
> observed again!
>                   */
>                  xhci_warn(xhci, "Virt dev invalid for slot_id 0x%x!\n",
>                          udev->slot_id);
>                  return -EINVAL;
>          }

I suggest sending this to the linux-usb@vger mailing list and cc: the
xhci author/maintainer so they are aware of this.

thanks,

greg k-h
