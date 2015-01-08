Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbbAHCFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 21:05:06 -0500
Received: from mga02.intel.com ([134.134.136.20]:35176 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509AbbAHCFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 21:05:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="437812684"
Message-ID: <1420682701.6201.79.camel@intel.com>
Subject: Re: [LKP] [null_blk] f2298c0403b:
From: Huang Ying <ying.huang@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Date: Thu, 08 Jan 2015 10:05:01 +0800
In-Reply-To: <CACVXFVPcRrKR36WpGxjcLUQAqLYbFmM-6uyavgFVA8PaZRFsFQ@mail.gmail.com>
References: <1420598028.6201.70.camel@intel.com>
	 <54AD4F98.6070702@kernel.dk> <1420678371.6201.78.camel@intel.com>
	 <CACVXFVPcRrKR36WpGxjcLUQAqLYbFmM-6uyavgFVA8PaZRFsFQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2015-01-08 at 09:52 +0800, Ming Lei wrote:
> On Thu, Jan 8, 2015 at 8:52 AM, Huang Ying <ying.huang@intel.com> wrote:
> > On Wed, 2015-01-07 at 08:24 -0700, Jens Axboe wrote:
> >> On 01/06/2015 07:33 PM, Huang Ying wrote:
> >> > FYI, we noticed the below changes on
> >> >
> >> > commit f2298c0403b0dfcaef637eba0c02c4a06d7a25ab ("null_blk: multi queue aware block test driver")
> >> >
> >> >
> >> > testbox/testcase/testparams: vm-kbuild-yocto-i386/boot/1
> >> >
> >> > 320ae51feed5c2f1  f2298c0403b0dfcaef637eba0c
> >> > ----------------  --------------------------
> >> >         fail:runs  %reproduction    fail:runs
> >> >             |             |             |
> >> >             :10         100%          10:10    kmsg.VFS:could_not_find_a_valid_V7_on_nullb1
> >> >             :10         100%          10:10    kmsg.VFS:could_not_find_a_valid_V7_on_nullb0
> >> >            1:10         -10%            :10    kmsg.vm86_32:could_not_access_userspace_vm86_info
> >> >
> >> > vm-kbuild-yocto-i386: qemu-system-i386 -enable-kvm
> >> > Memory: 320M
> >> >
> >> > [    1.971241] mtip32xx Version 1.2.6os3
> >> > [    1.971311] blk-mq: CPU -> queue map
> >> > [    1.971312]   CPU 0 -> Queue 0
> >> > [    1.971314]   CPU 1 -> Queue 0
> >> > [    1.971628]  nullb0: unknown partition table
> >> > [    1.971748] blk-mq: CPU -> queue map
> >> > [    1.971749]   CPU 0 -> Queue 0
> >> > [    1.971751]   CPU 1 -> Queue 0
> >> > [    1.972023]  nullb1: unknown partition table
> >> > [    1.972096] null: module loaded
> >> > [    1.972131] ibmasm: IBM ASM Service Processor Driver version 1.0 loaded
> >> >
> >> > I think this is at least confusing for the end user.
> >>
> >> Sorry, not sure I follow at all. If you're expecting the null block
> >> driver to actually store data, then yes, you are going to have a bad
> >> time. It's a test tool for storage stack development.
> >
> > I understand that null block is just for testing.
> >
> > I just think the message like:
> >
> > [    1.971628]  nullb0: unknown partition table
> >
> > may confuse the end user.  They may think there are something wrong.
> > But it is not.  Is there any way to suppress this?
> 
> It can be logged for any normal block devices which have not be
> partitioned, and users should have understood that, IMO.

Then it is OK.  Thanks for explanation.

Best Regards,
Huang, Ying


