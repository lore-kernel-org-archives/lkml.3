Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113Ab3JKNd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:33:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab3JKNd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:33:56 -0400
Date: Fri, 11 Oct 2013 06:32:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Youquan Song <youquan.song@intel.com>
Cc: dan.j.williams@intel.com, vinod.koul@intel.com,
        andriy.shevchenko@intel.com, mika.westerberg@intel.com,
        linux-kernel@vger.kernel.org,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH 2/2] dma: calculate the data tranferred by 8250
Message-ID: <20131011133200.GA32689@kroah.com>
References: <1381527738-9339-1-git-send-email-youquan.song@intel.com>
 <1381527738-9339-2-git-send-email-youquan.song@intel.com>
 <1381527738-9339-3-git-send-email-youquan.song@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381527738-9339-3-git-send-email-youquan.song@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 11, 2013 at 05:42:18PM -0400, Youquan Song wrote:
> When using UART transfers data by DMA mode, but it always shows 0 at 
> /sys/class/dma/dma0chan*/bytes_transferred.
> 
> Call the new function to calculate how many the data has been transferred
>  after doing it by DMA mode. 

How nice, you just leaked to userspace the size of passwords and other
sensitive things typed into a serial console :(

No, we can't do this, we fixed up this problem in other places we leaked
the transmition of serial data through proc and sysfs files, let's not
add new ones and go backwards in security.

Sorry, we can't do this, and I really doubt that it matters.

greg k-h
