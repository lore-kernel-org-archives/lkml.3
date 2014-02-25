Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbaBYPSA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:18:00 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:47589 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbaBYPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:17:59 -0500
Date: Tue, 25 Feb 2014 10:17:55 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Li Zefan <lizefan@huawei.com>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3] sysfs: fix namespace refcnt leak
Message-ID: <20140225151755.GG26788@htj.dyndns.org>
References: <530C7E6C.2020500@huawei.com>
 <20140225144256.GB26788@htj.dyndns.org>
 <20140225151955.GA8322@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225151955.GA8322@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 07:19:55AM -0800, Greg Kroah-Hartman wrote:
> On Tue, Feb 25, 2014 at 09:42:56AM -0500, Tejun Heo wrote:
> > On Tue, Feb 25, 2014 at 07:28:44PM +0800, Li Zefan wrote:
> > > As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> > > ns refcnt unconditionally in sysfs_mount(), and instead we should
> > > get the refcnt only when kernfs_mount() allocated a new superblock.
> > > 
> > > v2:
> > > - Changed the name of the new argument, suggested by Tejun.
> > > - Made the argument optional, suggested by Tejun.
> > > 
> > > v3:
> > > - Make the new argument as second-to-last arg, suggested by Tejun.
> > > 
> > > Reviewed-by: Tejun Heo <tj@kernel.org>
> > > Signed-off-by: Li Zefan <lizefan@huawei.com>
> > 
> >  Acked-by: Tejun Heo <tj@kernel.org>
> 
> Is this needed for 3.14-final or 3.15?

It also fixes sysfs refcnting, so should also be applied to 3.14, I
think.

Thanks.

-- 
tejun
