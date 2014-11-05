Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249AbaKED3s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:29:48 -0500
Received: from mail-qg0-f47.google.com ([209.85.192.47]:58978 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaKED3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:29:46 -0500
Date: Tue, 4 Nov 2014 22:29:43 -0500
From: Tejun Heo <tj@kernel.org>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Weng Meiling <wengmeiling.weng@huawei.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Frans Klaver <fransklaver@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
Message-ID: <20141105032943.GB29392@htj.dyndns.org>
References: <543E1754.8040701@huawei.com>
 <543F25D3.8010708@huawei.com>
 <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com>
 <543F7289.8010807@huawei.com>
 <20141016091328.GB24374@kroah.com>
 <544765D0.70302@huawei.com>
 <20141104191535.GI14459@htj.dyndns.org>
 <54598503.1060905@huawei.com>
 <20141105031345.GA29392@htj.dyndns.org>
 <5459992B.1040700@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5459992B.1040700@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Nov 05, 2014 at 11:27:39AM +0800, Yijing Wang wrote:
> Keep the parent directory looks good to me,  we could only add kobject_get(&parent)
> after the parent dir be created.
> 
> ....
> 		/* or create a new class-directory at the parent device */
> 		k = class_dir_create_and_add(dev->class, parent_kobj);
> 		/* do not emit an uevent for this simple "glue" directory */
> 		kobject_get(k);  <--------add parent ref count for first child device.

The created directory would already have the base ref.  I don't think
you need the above.  Just never put the parent once created.

Greg, how does this sound to you?

Thanks.

-- 
tejun
