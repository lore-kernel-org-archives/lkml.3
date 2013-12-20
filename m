Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3LTPdE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:33:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52416 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3LTPdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:33:00 -0500
Date: Fri, 20 Dec 2013 07:33:09 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Haverkamp <haver@linux.vnet.ibm.com>
Cc: fengguang.wu@intel.com, jim.epost@gmail.com, sfr@canb.auug.org.au,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        kbuild-all@01.org
Subject: Re: [PATCH 2/2] GenWQE: Replace dynamic_hex_dump with
 print_hex_dump_debug
Message-ID: <20131220153309.GA21797@kroah.com>
References: <CA+r1Zhimt7Xusnc4kkkVqfoRhfZRnreMmZqaN7WP7rSpZ3XTvw@mail.gmail.com>
 <1387553171-31469-2-git-send-email-haver@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387553171-31469-2-git-send-email-haver@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 04:26:11PM +0100, Frank Haverkamp wrote:
> As requested by Greg, replacing the hexdump function from dynamic_debug.h
> with one defined in printk.h. I hope I picked the right one.

No, just use the "%*ph" modifier for printk.

So, you can do it all on just one line:
  	scnprintf(prefix, sizeof(prefix), "%s %s: %*ph\n",
  		  GENWQE_DEVNAME, pci_name(pci_dev), size, buff);

And even then, do you really need this genwqe_hexdump() function at all
anymore?  What is it used for?

greg k-h
