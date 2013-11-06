Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab3KFI4q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:56:46 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:58683 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3KFI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:56:45 -0500
Date: Wed, 6 Nov 2013 00:58:59 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: dmitry.torokhov@gmail.com, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] devres: Freeing the drs after all release() are called
Message-ID: <20131106085859.GB9487@kroah.com>
References: <1383720018.3650.37.camel@cliu38-desktop-build>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383720018.3650.37.camel@cliu38-desktop-build>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 02:40:18PM +0800, Chuansheng Liu wrote:
> 
> In release_nodes(), it will call dr->node.release() and kfree
> dr one by one.
> 
> But sometimes the previous dr maybe be used by next .release(),
> such as:
> [50314.855534]  [<c12b172f>] ? synchronize_irq+0x3f/0xb0
> [50314.861193]  [<c12b18e9>] __free_irq+0x149/0x200
> [50314.866367]  [<c12b19e3>] free_irq+0x43/0xa0
> [50314.871152]  [<c12b4864>] devm_irq_release+0x14/0x20
> [50314.876713]  [<c169e806>] release_nodes+0x136/0x1b0
> [50314.882178]  [<c169ee79>] devres_release_all+0x39/0x60
> [50314.887935]  [<c169b411>] __device_release_driver+0x71/0xd0
> 
> the free_irq() will sync the last irq handling, which maybe use
> freed dr, then it will cause memory corruption.
> 
> Here split the dr kfreeing actions after all dr->node.release().

But you aren't really solving any problems here, how is dr being used
after the release function is called?  Who is doing it in such a way
that this change would really fix anything?

thanks,

greg k-h
