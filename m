Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3IMRAa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:00:30 -0400
Received: from dkim2.fusionio.com ([66.114.96.54]:50123 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab3IMRAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:00:25 -0400
X-ASG-Debug-ID: 1379091624-03d6a50f736b3e0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Guenter Roeck <linux@roeck-us.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>
From: Chris Mason <chris.mason@fusionio.com>
In-Reply-To: <20130913163535.GA5681@roeck-us.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Mark Fasheh <mfasheh@suse.de>, Zach Brown <zab@redhat.com>
References: <20130913133314.GA20461@roeck-us.net>
 <CAMuHMdWoNo9U0DCRoXt8V2d1SiSxX5Sku9rNvg+9MiX++XjVRg@mail.gmail.com>
 <20130913163535.GA5681@roeck-us.net>
Message-ID: <20130913170022.18785.82013@localhost.localdomain>
User-Agent: alot/0.3.4
Subject: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
Date: Fri, 13 Sep 2013 13:00:22 -0400
X-ASG-Orig-Subj: Re: Build failures due to commit 416161db (btrfs: offline dedupe)
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1379091624
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -1.90
X-Barracuda-Spam-Status: No, SCORE=-1.90 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=CN_BODY_332, INFO_TLD
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.140576
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
	0.12 CN_BODY_332            BODY: CN_BODY_332
	0.00 INFO_TLD               URI: Contains an URL in the INFO top-level domain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Guenter Roeck (2013-09-13 12:35:35)
> On Fri, Sep 13, 2013 at 03:52:43PM +0200, Geert Uytterhoeven wrote:
> > On Fri, Sep 13, 2013 at 3:33 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > > fs/btrfs/ioctl.c: In function 'btrfs_ioctl_file_extent_same':
> > > fs/btrfs/ioctl.c:2802:3: error: implicit declaration of function '__put_user_unaligned' [-Werror=implicit-function-declaration]
> > > cc1: some warnings being treated as errors
> > > make[2]: *** [fs/btrfs/ioctl.o] Error 1
> > > make[2]: *** Waiting for unfinished jobs....
> > >
> > > Seen with alpha:allmodconfig, arm:allmodconfig, m68k:allmodconfig, and
> > > xtensa:allmodconfig.
> > 
> > Known issue, cfr. my early warning 10 days ago:
> > 
> > "Btrfs is the first user of __put_user_unaligned() outside the compat code,
> > hence now all 32-bit architectures should make sure to implement this, too."
> > 
> > http://marc.info/?l=linux-arch&m=137820065929216&w=2
> > 
> > and today's thread https://lkml.org/lkml/2013/9/12/814
> > 
> 
> It doesn't seem right that a patch breaks the build for several platforms, and
> the problem is then blamed on the platform code instead of the code that is
> introducing the problem.
> 
> Maybe we should add BROKEN to the btrfs dependencies for the affected platforms.
> After all, it _is_ broken.

I'm happy to fix this with a bigger put of the info struct, just
let me know the preferred arch-happy solution.

-chris
