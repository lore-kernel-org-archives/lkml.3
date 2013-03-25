Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902Ab3CYG3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 02:29:22 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:50649 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126Ab3CYG3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 02:29:20 -0400
Date: Mon, 25 Mar 2013 09:29:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: wwang <wei_wang@realsil.com.cn>
Cc: cjb@laptop.org, sameo@linux.intel.com, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        rogerable@realtek.com, devel@linuxdriverproject.org
Subject: Re: [PATCH] mfd:rtsx: Support RTS5249
Message-ID: <20130325062900.GC9189@mwanda>
References: <1364177636-4294-1-git-send-email-wei_wang@realsil.com.cn>
 <20130325060038.GD9138@mwanda>
 <514FED71.8020307@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <514FED71.8020307@realsil.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 02:23:45PM +0800, wwang wrote:
> 于 2013年03月25日 14:00, Dan Carpenter 写道:
> >On Mon, Mar 25, 2013 at 10:13:56AM +0800, wei_wang@realsil.com.cn wrote:
> >>+static int rts5249_optimize_phy(struct rtsx_pcr *pcr)
> >>+{
> >>+	int err;
> >>+
> >>+	err = rtsx_pci_write_phy_register(pcr, 0x19, 0xFE46);
> >>+	if (err < 0)
> >>+		return err;
> >>+
> >>+	mdelay(1);
> >Why do we have the mdelay() and the later msleep(5)?
> >rtsx_pci_write_phy_register() busy loops until the write succeeds or
> >it returns -ETIMEOUT.  The extra wait here seems unnecessary.
> >
> >regards,
> >dan carpenter
> >
> >
> >.
> 
> Hi,
> 
> The busy loops in rtsx_pci_write_phy_register only tell us that the
> write sequence succeeds. The device still needs to wait for a while
> until the internal signal stable. Or else the timing won't fit the
> requirement.
> All of the delays in the driver are necessary.

Ok.  Cool.

regards,
dan carpenter

