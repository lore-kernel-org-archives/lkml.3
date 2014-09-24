Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbaIXJpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:45:52 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:48781 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbaIXJps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:45:48 -0400
Date: Wed, 24 Sep 2014 12:45:30 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Daeseok Youn <daeseok.youn@gmail.com>
Cc: lidza.louina@gmail.com, markh@compro.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging: dgap: use dgap_release_remap() in
 dgap_cleanup_board()
Message-ID: <20140924094530.GC5811@mwanda>
References: <20140923002236.GA20782@devel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923002236.GA20782@devel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:22:36AM +0900, Daeseok Youn wrote:
>  static void dgap_release_remap(struct board_t *brd)
>  {
> -	release_mem_region(brd->membase, 0x200000);
> -	release_mem_region(brd->membase + PCI_IO_OFFSET, 0x200000);
> -	iounmap(brd->re_map_membase);
> -	iounmap(brd->re_map_port);
> +	if (brd->re_map_membase) {

I hate this if conditions.  Let's not complicate dgap_release_remap(),
let's fix the callers instead.  Especially dgap_init_module() is a
totally sucky function with bad unwinding.

Let's not apply this patch.

regards,
dan carpenter

