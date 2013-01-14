Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295Ab3ANJ3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 04:29:48 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.189.228]:32077 "EHLO
	smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab3ANJ3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 04:29:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,467,1355097600"; 
   d="scan'208";a="440050472"
Date: Mon, 14 Jan 2013 10:29:41 +0100
From: Matt Wilson <msw@amazon.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <stable@vger.kernel.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        Annie Li <annie.li@oracle.com>, <xen-devel@lists.xen.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] xen/grant-table: correctly initialize grant table
 version 1
Message-ID: <20130114092936.GB15043@u109add4315675089e695.ant.amazon.com>
References: <1355997710.26722.12.camel@zakaz.uk.xensource.com>
 <1357470882-17345-1-git-send-email-msw@amazon.com>
 <20130111213550.GA31149@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130111213550.GA31149@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 04:35:50PM -0500, Konrad Rzeszutek Wilk wrote:
> 
> With this patch I get:
> 
> [    2.555087] GHES: HEST is not enabled!
> [    2.560522] ioatdma: Intel(R) QuickData Technology Driver 4.00
> [    2.569651] ------------[ cut here ]------------
> [    2.570529] kernel BUG at /home/konrad/linux/drivers/xen/grant-table.c:1175!

You dropped part of a hunk when you applied the patch:

@@ -1127,17 +1128,17 @@ static void gnttab_request_version(void)
                panic("we need grant tables version 2, but only version 1 is a
        } else {
                grant_table_version = 1;
+               grefs_per_grant_frame = PAGE_SIZE / sizeof(struct grant_entry_
                gnttab_interface = &gnttab_v1_ops;
        }
        printk(KERN_INFO "Grant tables using version %d layout.\n",
                grant_table_version);
 }
 
I can rebase to v3.8-rc3 if that would help.

Matt
