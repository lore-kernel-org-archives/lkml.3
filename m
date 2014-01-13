Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364AbaAMHqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 02:46:19 -0500
Received: from mail-pd0-f174.google.com ([209.85.192.174]:55505 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbaAMHqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 02:46:17 -0500
Date: Sun, 12 Jan 2014 23:46:13 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Caizhiyong <caizhiyong@hisilicon.com>
Cc: Huang Shijie <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Quyaxin <quyaxin@hisilicon.com>
Subject: Re: [PATCH] mtd: nand:  assign mtd->name in find_full_id_nand
Message-ID: <20140113074613.GI1992@norris-Latitude-E6410>
References: <C3050A4DBA34F345975765E43127F10F25E47E20@SZXEMA512-MBX.china.huawei.com>
 <20131226021937.GA6752@shlinux2.ap.freescale.net>
 <20140111201019.GD1992@norris-Latitude-E6410>
 <C3050A4DBA34F345975765E43127F10F25E48C13@SZXEMA512-MBX.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C3050A4DBA34F345975765E43127F10F25E48C13@SZXEMA512-MBX.china.huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 04:12:45AM +0000, Caizhiyong wrote:
> > -----Original Message-----
> > From: Brian Norris [mailto:computersforpeace@gmail.com]
> > Sent: Sunday, January 12, 2014 4:10 AM
> > 
> > On Thu, Dec 26, 2013 at 10:19:39AM +0800, Huang Shijie wrote:
> > > On Thu, Dec 26, 2013 at 01:51:58AM +0000, Caizhiyong wrote:
> > > > From: Cai Zhiyong <caizhiyong@huawei.com>
> > > > Date: Wed, 25 Dec 2013 21:19:21 +0800
> > > > Subject: [PATCH] mtd: nand: assign mtd->name in find_full_id_nand
> > > >
> > > > This patch assigned the type->name to mtd->name when mtd->name is
> > > > NULL in function "find_full_id_nand".
> > > > mtd->name is NULL may cause some problem.
> > > >
> > > > Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
> > > Acked-by: Huang Shijie <b32955@freescale.com>
> > 
> > Thanks, the patch looks good. Pushed to l2-mtd.git.
> > 
> > Wouldn't this trigger an exception when reading
> > /sys/class/mtd/mtdX/name? If so, should this be marked for stable?
> 
> View the source code, if mtd->name is NULL, cat "/sys/class/mtd/mtdX/name" will get string "(null)".
> 
> static ssize_t mtd_name_show(struct device *dev, struct device_attribute *attr, char *buf)
> {
> 	struct mtd_info *mtd = dev_get_drvdata(dev);
> 
> 	return snprintf(buf, PAGE_SIZE, "%s\n", mtd->name);
> }

Thanks, I forgot that the kernel's printf-like functions handle NULL
pointers gracefully. In that case, this probably doesn't need to be in
-stable.

Brian
