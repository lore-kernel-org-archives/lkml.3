Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaAQPRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:17:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38219 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaAQPRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:17:07 -0500
Date: Fri, 17 Jan 2014 07:17:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: devel@driverdev.osuosl.org, Peng Tao <tao.peng@emc.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        linux-kernel@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] staging: lustre: fix GFP_ATOMIC macro usage
Message-ID: <20140117151735.GB16623@kroah.com>
References: <1389948416-26390-1-git-send-email-m.szyprowski@samsung.com>
 <20140117143329.GA6877@kroah.com>
 <20140117145128.GR7444@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140117145128.GR7444@mwanda>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 05:51:28PM +0300, Dan Carpenter wrote:
> We will want to get rid of lustre's custom allocator before this gets
> out of staging.
> 
> But one feature that the lustre allocator has which is pretty neat is
> that it lets you debug how much memory the filesystem is using.  Is
> there a standard way to find this information?

Create your own mempool/slab/whatever_it's_called and look in the
debugfs or proc files for the allocator usage, depending on the memory
allocator the kernel is using.

That's how the rest of the kernel does it, no reason lustre should be
any different.

thanks,

greg k-h
