Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbaETIJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 04:09:06 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:48494 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478AbaETIJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 04:09:00 -0400
Date: Tue, 20 May 2014 10:08:53 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: Benjamin LaHaise <bcrl@kvack.org>
cc: Anatol Pomozov <anatol.pomozov@gmail.com>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: hanging aio process
In-Reply-To: <20140519180851.GD2915@kvack.org>
Message-ID: <alpine.LFD.2.11.1405200950480.1606@denkbrett>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett> <20140519180851.GD2915@kvack.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052008-2966-0000-0000-00000B550734
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014, Benjamin LaHaise wrote:
> On Mon, May 19, 2014 at 07:38:51PM +0200, Sebastian Ott wrote:
> > Hello,
> > 
> > on the latest kernel a fio job with 4 workers using libaio hangs.
> 
> Is more than one process stuck in state D when the hang occurs?  If so, 
> what does a backtrace show for the stuck processes (or are there any 
> hung process warnings issued)?

I've seen both - just one or multiple processes in D state. Here it are 2:

./fio ../../test.job 
file1: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
file2: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
file3: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
file4: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
fio-2.1.8
Starting 4 processes
Jobs: 2 (f=0): [m__m] [100.0% done] [0KB/0KB/0KB /s] [0/0/0 iops] [eta 00m:00s]



[   58.125227] fio             D 00000000006a2dfe     0   804    800 0x00000001
[   58.125229]        000000007b52fb88 0000000000ab3800 0000000000ab3800 00000000009e60b0 
[   58.125229]        0000000000ab3800 00000000789284d8 0000000002e0f800 0000000078928000 
[   58.125229]        00000000797aec00 0000000000ab3800 0000000000ab3800 00000000009e60b0 
[   58.125229]        0000000000ab3800 0000000000000000 0000000002e0f800 0000000078928000 
[   58.125229]        00000000006b39b0 00000000006a377a 000000007b52fbc8 000000007b52fd20 
[   58.125238] Call Trace:
[   58.125240] ([<00000000006a377a>] __schedule+0x562/0xcc8)
[   58.125241]  [<00000000006a2dfe>] schedule_timeout+0x1ee/0x270
[   58.125243]  [<00000000006a4acc>] wait_for_common+0x100/0x1d0
[   58.125246]  [<00000000002ca3fe>] SyS_io_destroy+0x9a/0xdc
[   58.125247]  [<00000000006a80f8>] sysc_nr_ok+0x22/0x28
[   58.125248]  [<000003fffd21c6d2>] 0x3fffd21c6d2
[   58.125250] fio             D 00000000006a2dfe     0   811    800 0x00000001
[   58.125252]        000000007d82bb88 0000000000ab3800 0000000000ab3800 00000000009e60b0 
[   58.125252]        0000000000ab3800 000000007b0869f8 0000000002e0f800 000000007b086520 
[   58.125252]        000000007ea0f600 0000000000ab3800 0000000000ab3800 00000000009e60b0 
[   58.125252]        0000000000ab3800 0000000000000000 0000000002e0f800 000000007b086520 
[   58.125252]        00000000006b39b0 00000000006a377a 000000007d82bbc8 000000007d82bd20 
[   58.125261] Call Trace:
[   58.125263] ([<00000000006a377a>] __schedule+0x562/0xcc8)
[   58.125264]  [<00000000006a2dfe>] schedule_timeout+0x1ee/0x270
[   58.125266]  [<00000000006a4acc>] wait_for_common+0x100/0x1d0
[   58.125267]  [<00000000002ca3fe>] SyS_io_destroy+0x9a/0xdc
[   58.125269]  [<00000000006a80f8>] sysc_nr_ok+0x22/0x28
[   58.125270]  [<000003fffd21c6d2>] 0x3fffd21c6d2


> It is entirely possible the bug isn't 
> caused by the referenced commit, as the commit you're pointing to merely 
> makes io_destroy() syscall wait for all aio outstanding to complete 
> before returning.

I cannot reproduce this when I revert said commit (on top of 14186fe). If
that matters - the arch is s390.

Regards,
Sebastian
> 
> 		-ben
> 
> > git bisect points to:
> > 	commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c
> > 	Author: Anatol Pomozov <anatol.pomozov@gmail.com>
> > 	Date:   Tue Apr 15 11:31:33 2014 -0700
> > 
> > 	    aio: block io_destroy() until all context requests are completed
> > 
> > 
> > The fio workers are on the wait_for_completion in sys_io_destroy.
> > 
> > Regards,
> > Sebastian
> > [global]
> > blocksize=4K
> > size=256M
> > rw=randrw
> > verify=md5
> > iodepth=32
> > ioengine=libaio
> > direct=1
> > end_fsync=1
> > 
> > [file1]
> > filename=/dev/scma
> > 
> > [file2]
> > filename=/dev/scmbw
> > 
> > [file3]
> > filename=/dev/scmc
> > 
> > [file4]
> > filename=/dev/scmx
> 
> 
> -- 
> "Thought is the essence of where you are now."
> 
> 

