Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbaE3Jl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 05:41:27 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58174 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaE3JlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 05:41:23 -0400
Date: Fri, 30 May 2014 11:41:18 +0200
From: Dongsu Park <dongsu.park@profitbricks.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jet Chen <jet.chen@intel.com>,
        Maurizio Lombardi <mlombard@redhat.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
Message-ID: <20140530094118.GA5207@gmail.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
 <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
 <CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
 <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

On 29.05.2014 00:59, Ming Lei wrote:
> On Wed, May 28, 2014 at 11:42 PM, Ming Lei <tom.leiming@gmail.com> wrote:
> > Would you mind explaining why bi_iter.bi_size need to be
> > decreased by 'len'? In the failure path, it wasn't added by
> > 'len', was it?
> 
> Actually, the correct thing may be like what did in the
> attached patch, as Maurizio discussed with me[1].

Yes, I agree. Your patch is the correct fix.
Please ignore my patch, and take yours,
<https://lkml.org/lkml/2014/5/29/370>

> Very interestingly, I have reproduced the problem one time
> with ext4/271 ext4/301 ext4/305, but won't with the attached
> patch after running it for 3 rounds.

I also had a trouble with reproducing this bug on my home desktop,
while I can reliably reproduce the bug on my office workstation.
I'm not quite sure what makes the difference.
(The same kernel, the same qemu version, the same xfstests version, etc.)

Anyway, coming back to my office, now I can confirm that your patch
fixes the bug. You can add:

Tested-by: Dongsu Park <dongsu.park@profitbricks.com>

Thanks,
Dongsu

> [tom@localhost xfstests]$ sudo ./check ext4/271 ext4/301 ext4/305
> FSTYP         -- ext4
> PLATFORM      -- Linux/x86_64 localhost 3.15.0-rc7-next-20140527+
> MKFS_OPTIONS  -- /dev/vdc
> MOUNT_OPTIONS -- -o acl,user_xattr /dev/vdc /mnt/scratch
> 
> ext4/271 1s ... 1s
> ext4/301 31s ... 32s
> ext4/305 181s ... 180s
> Ran: ext4/271 ext4/301 ext4/305
> Passed all 3 tests
> 
> Jet, could you test the attached patch?
> 
> [1], https://lkml.org/lkml/2014/5/27/327
> 
> 
> Thanks,
> -- 
> Ming Lei


