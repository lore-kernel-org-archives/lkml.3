Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158Ab3G3OLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 10:11:03 -0400
Received: from mail-qe0-f53.google.com ([209.85.128.53]:60551 "EHLO
	mail-qe0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076Ab3G3OLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 10:11:00 -0400
Date: Tue, 30 Jul 2013 10:10:56 -0400
From: Tejun Heo <tj@kernel.org>
To: Dennis Chen <xschen@tnsoft.com.cn>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH] race condition fixing in sysfs_create_dir
Message-ID: <20130730141056.GF12016@htj.dyndns.org>
References: <51F24612.6030509@tnsoft.com.cn>
 <51F24864.7070306@tnsoft.com.cn>
 <20130726133856.GD3013@htj.dyndns.org>
 <51F75E90.2090908@tnsoft.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F75E90.2090908@tnsoft.com.cn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 30, 2013 at 02:34:56PM +0800, Dennis Chen wrote:
> >I don't think sysfs is supposed to handle multiple actors trying to
> >populate and destroy the directory at the same time at all, so this
> >seems kinda moot.  Do you have a case where this actually matters?
>
> hello,Tejun. Nice. But seems I still have different opinion :). If
> you look at the 'sysfs_do_create_link_sd()' code, you will find a
> comment "target->sd can go away beneath us but is protected with
> sysfs_assoc_lock.  Fetch target_sd from it", don't you think the
> sysfs_create_dir is the same as the sysfs_do_create_link_sd()
> essentially? if the answer is yes meaning the parent dir can go away

No, one is targetting an unrelated directory wherever in the hierarchy
and the other one is targetting its direct parent.  They aren't the
same.

> when its sub-dir is creating by sysfs_create_dir, then the similar
> action should be taken as sysfs_create_link does. right?

If you own a sysfs directory, it's your responsibility to prevent
creation of new entries under it against your own removal.  The
implementation implicitly assumes that in many places.  Do you have a
use case where this is an actual problem?

Thanks.

-- 
tejun
