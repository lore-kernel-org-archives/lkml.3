Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab3LTQtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 11:49:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab3LTQtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 11:49:03 -0500
Date: Fri, 20 Dec 2013 08:49:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aaro Koskinen <aaro.koskinen@nsn.com>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>
Subject: Re: [PATCH] uio: fix devm_request_irq usage
Message-ID: <20131220164913.GA29422@kroah.com>
References: <1387549187-10068-1-git-send-email-aaro.koskinen@nsn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387549187-10068-1-git-send-email-aaro.koskinen@nsn.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 04:19:47PM +0200, Aaro Koskinen wrote:
> Commit e6789cd3dfb553077606ccafeb05e0043f072481 (uio: Simplify uio error
> path by using devres functions) converted uio to use devm_request_irq().
> This introduced a change in behaviour since the IRQ is associated with
> the parent device instead of the created UIO device. The IRQ will remain
> active after uio_unregister_device() is called, and some drivers will
> crash because of this. The patch fixes this.

What drivers crash because of this?  Any in-kernel drivers?

thanks,

greg k-h
