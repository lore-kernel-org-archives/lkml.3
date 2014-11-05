Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948AbaKEDxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 22:53:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51522 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbaKEDxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 22:53:35 -0500
Date: Tue, 4 Nov 2014 19:52:24 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Yijing Wang <wangyijing@huawei.com>,
        Weng Meiling <wengmeiling.weng@huawei.com>,
        Frans Klaver <fransklaver@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        akpm@linux-foundation.org, adilger.kernel@dilger.ca,
        Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
Message-ID: <20141105035224.GB9419@kroah.com>
References: <543F25D3.8010708@huawei.com>
 <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com>
 <543F7289.8010807@huawei.com>
 <20141016091328.GB24374@kroah.com>
 <544765D0.70302@huawei.com>
 <20141104191535.GI14459@htj.dyndns.org>
 <54598503.1060905@huawei.com>
 <20141105031345.GA29392@htj.dyndns.org>
 <5459992B.1040700@huawei.com>
 <20141105032943.GB29392@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105032943.GB29392@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 10:29:43PM -0500, Tejun Heo wrote:
> Hello,
> 
> On Wed, Nov 05, 2014 at 11:27:39AM +0800, Yijing Wang wrote:
> > Keep the parent directory looks good to me,  we could only add kobject_get(&parent)
> > after the parent dir be created.
> > 
> > ....
> > 		/* or create a new class-directory at the parent device */
> > 		k = class_dir_create_and_add(dev->class, parent_kobj);
> > 		/* do not emit an uevent for this simple "glue" directory */
> > 		kobject_get(k);  <--------add parent ref count for first child device.
> 
> The created directory would already have the base ref.  I don't think
> you need the above.  Just never put the parent once created.
> 
> Greg, how does this sound to you?

It makes sense, but I don't understand, what "parent" directory is going
away and causing problems?

thanks,

greg k-h
