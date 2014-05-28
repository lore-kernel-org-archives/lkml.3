Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbaE1RWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:22:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751757AbaE1RWC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:22:02 -0400
Date: Wed, 28 May 2014 19:21:50 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Jet Chen <jet.chen@intel.com>,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: [PATCH] bio: decrease bi_iter.bi_size by len in the fail path
Message-ID: <20140528172150.GA3261@dhcp-27-189.brq.redhat.com>
References: <20140527112459.GF2205@dhcp-27-189.brq.redhat.com>
 <1401289778-9840-1-git-send-email-dongsu.park@profitbricks.com>
 <CACVXFVO6uW3KoVPoeb+O0txuY2Ji6BO1Sob1e-g7NmZBv9MPBQ@mail.gmail.com>
 <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNNc3dRshmMYNgS+pn54RC2dyQkJFOy1=HJdXfUfuhAMQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming,

On Thu, May 29, 2014 at 12:59:19AM +0800, Ming Lei wrote:
> 
> Actually, the correct thing may be like what did in the
> attached patch, as Maurizio discussed with me[1].
> 
> Very interestingly, I have reproduced the problem one time
> with ext4/271 ext4/301 ext4/305, but won't with the attached
> patch after running it for 3 rounds.
> 
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

There is a little mistake in your patch, you removed bio->bi_iter.bi_size += len;
after the "done" label,
but be careful that at line 747 there is a "goto done"... bi_size should be incremented
before jumping there.


Thanks,
Maurizio Lombardi

