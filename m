Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab3CJLuO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 07:50:14 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:52972 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778Ab3CJLuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 07:50:12 -0400
Date: Sun, 10 Mar 2013 04:50:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Greg KH <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
Message-ID: <20130310115006.GA24522@htj.dyndns.org>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
 <20130308204113.GA15334@kroah.com>
 <CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
 <CA+ydwtqHtwizg1=-KeLOjUUr+tzoFSPWRaeitE=10sm+pOYYKw@mail.gmail.com>
 <CACVXFVNJR69B=0G59FEqnu4Vhpn0_S_gf8j+vdUG2+0oLSPi_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNJR69B=0G59FEqnu4Vhpn0_S_gf8j+vdUG2+0oLSPi_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jens)

Hello,

On Sun, Mar 10, 2013 at 04:53:11PM +0800, Ming Lei wrote:
> On Sun, Mar 10, 2013 at 12:36 AM, Tommi Rantala <tt.rantala@gmail.com> wrote:
> > [   40.089036]  [<ffffffff81222e29>] sysfs_get_dirent+0x39/0x80
> > [   40.089036]  [<ffffffff81224ad9>] sysfs_remove_group+0x29/0x100
> > [   40.089036]  [<ffffffff8113f2c4>] blk_trace_remove_sysfs+0x14/0x20
> > [   40.089036]  [<ffffffff813453ae>] blk_unregister_queue+0x5e/0x90
> > [   40.089036]  [<ffffffff8134d417>] del_gendisk+0x107/0x250
> > [   40.089036]  [<ffffffff814f66b8>] loop_remove+0x18/0x40
> 
> Then the crash is triggered in device release path, which should have
> been avoided in device add path.
> 
> If we want to fix the problem completely, add_disk() must handle failure
> path correctly and return error code on failures, which may involve big
> work, since add_disk() are called by 50+ drivers.

Yeah, add_disk() has been broken like that since forever.  We really
need to fix it properly.  Any volunteers?

Thanks.

-- 
tejun
