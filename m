Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751288AbaAMEO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 23:14:57 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:11462 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbaAMEOx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 23:14:53 -0500
From: Caizhiyong <caizhiyong@hisilicon.com>
To: Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <b32955@freescale.com>
CC: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Wanglin (Albert)" <albert.wanglin@hisilicon.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Quyaxin <quyaxin@hisilicon.com>
Subject: RE: [PATCH] mtd: nand:  assign mtd->name in find_full_id_nand
Thread-Topic: [PATCH] mtd: nand:  assign mtd->name in find_full_id_nand
Thread-Index: Ac8B3Q7fqVWcyWsLTCatba+p9jt2RP//gaGAgBpQcYD//WWusA==
Date: Mon, 13 Jan 2014 04:12:45 +0000
Message-ID: <C3050A4DBA34F345975765E43127F10F25E48C13@SZXEMA512-MBX.china.huawei.com>
References: <C3050A4DBA34F345975765E43127F10F25E47E20@SZXEMA512-MBX.china.huawei.com>
 <20131226021937.GA6752@shlinux2.ap.freescale.net>
 <20140111201019.GD1992@norris-Latitude-E6410>
In-Reply-To: <20140111201019.GD1992@norris-Latitude-E6410>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.223.53]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Brian Norris [mailto:computersforpeace@gmail.com]
> Sent: Sunday, January 12, 2014 4:10 AM
> To: Huang Shijie; Caizhiyong
> Cc: linux-mtd@lists.infradead.org; Wanglin (Albert); David Woodhouse;
> linux-kernel@vger.kernel.org; Artem Bityutskiy
> Subject: Re: [PATCH] mtd: nand: assign mtd->name in find_full_id_nand
> 
> Hi,
> 
> On Thu, Dec 26, 2013 at 10:19:39AM +0800, Huang Shijie wrote:
> > On Thu, Dec 26, 2013 at 01:51:58AM +0000, Caizhiyong wrote:
> > > From: Cai Zhiyong <caizhiyong@huawei.com>
> > > Date: Wed, 25 Dec 2013 21:19:21 +0800
> > > Subject: [PATCH] mtd: nand: assign mtd->name in find_full_id_nand
> > >
> > > This patch assigned the type->name to mtd->name when mtd->name is
> > > NULL in function "find_full_id_nand".
> > > mtd->name is NULL may cause some problem.
> > >
> > > Signed-off-by: Cai Zhiyong <caizhiyong@huawei.com>
> > Acked-by: Huang Shijie <b32955@freescale.com>
> 
> Thanks, the patch looks good. Pushed to l2-mtd.git.
> 
> Wouldn't this trigger an exception when reading
> /sys/class/mtd/mtdX/name? If so, should this be marked for stable?

View the source code, if mtd->name is NULL, cat "/sys/class/mtd/mtdX/name" will get string "(null)".

static ssize_t mtd_name_show(struct device *dev, struct device_attribute *attr, char *buf)
{
	struct mtd_info *mtd = dev_get_drvdata(dev);

	return snprintf(buf, PAGE_SIZE, "%s\n", mtd->name);
}

