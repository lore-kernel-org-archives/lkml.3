Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbaEKV44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 17:56:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755717AbaEKV4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 17:56:55 -0400
Date: Sun, 11 May 2014 23:55:22 +0200
From: Mateusz Guzik <mguzik@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: xiaoming.wang@intel.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, chuansheng.liu@intel.com,
        dongxing.zhang@intel.com
Subject: Re: [PATCH] net: ipv4: current group_info should be put after using.
Message-ID: <20140511215521.GA12224@mguzik.redhat.com>
References: <1397493045.2575.8.camel@wxm-ubuntu>
 <20140413.225407.1762639913754561393.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140413.225407.1762639913754561393.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 10:54:07PM -0400, David Miller wrote:
> From: "Wang, Xiaoming" <xiaoming.wang@intel.com>
> Date: Mon, 14 Apr 2014 12:30:45 -0400
> 
> > Plug a group_info refcount leak in ping_init.
> > group_info is only needed during initialization and 
> > the code failed to release the reference on exit.
> > While here move grabbing the reference to a place 
> > where it is actually needed.
> > 
> > Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
> > Signed-off-by: Zhang Dongxing <dongxing.zhang@intel.com>
> > Signed-off-by: xiaoming wang <xiaoming.wang@intel.com>
> 
> Applied and queued up for -stable, thanks.

I see this only made its way to 3.12 kernel, what is holding up inclusion
in other kernels? (or maybe this question should be directed at someone
else?)

The bug was introduced with:
commit c319b4d76b9e583a5d88d6bf190e079c4e43213d
Author: Vasiliy Kulikov <segoon@openwall.com>
Date:   Fri May 13 10:01:00 2011 +0000
    net: ipv4: add IPPROTO_ICMP socket kind

starting with 3.0.

Thanks,
-- 
Mateusz Guzik
