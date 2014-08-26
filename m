Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaHZVAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 17:00:11 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35757 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaHZVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 17:00:09 -0400
MIME-Version: 1.0
In-Reply-To: <20140826114707.GA16372@amd>
References: <1405397216-909-1-git-send-email-dinguyen@altera.com>
	<53C4D874.2040206@samsung.com>
	<20140814184710.GA11558@amd.pavel.ucw.cz>
	<53ED2262.50604@gmail.com>
	<20140814210252.GB26857@amd.pavel.ucw.cz>
	<20140826114707.GA16372@amd>
Date: Tue, 26 Aug 2014 16:00:08 -0500
Message-ID: <CADhT+wdx2SsHnk=zML7a6mUVJxvLQ9ARO16QoYYsopAqhw7cow@mail.gmail.com>
Subject: Re: 3.17-rc2: root=/dev/mmcblk0p2 command line parsing fails
From: Dinh Nguyen <dinh.linux@gmail.com>
To: Pavel Machek <pavel@denx.de>
Cc: Jaehoon Chung <jh80.chung@samsung.com>, Dinh Nguyen <dinguyen@altera.com>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, arm@kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        kernel list <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 6:47 AM, Pavel Machek <pavel@denx.de> wrote:
> Hi!
>
>> > > mmc0: new SDHC card at address b368
>> > > mmcblk0: mmc0:b368 USD   7.45 GiB
>> > >  mmcblk0: p1 p2 p3 p4
>> > > VFS: Cannot open root device "mmcblk0p2" or unknown-block(0,0): error
>> > > -6
>> > > Please append a correct "root=" boot option; here are the available
>> > > partitions:
>> > > b300         7822336 mmcblk0  driver: mmcblk
>> > >   b301          102400 mmcblk0p1 00082434-01
>> > >   b302         1048576 mmcblk0p2 00082434-02
>> > >   b303            1024 mmcblk0p3 00082434-03
>> > >   b304         6086656 mmcblk0p4 00082434-04
>> > > Kernel panic - not syncing: VFS: Unable to mount root fs on
>> > > unknown-block(0,0)
>> > > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.16.0-11208-gef74117-dirty
>> > > #2
>> >
>> > Hmm...today's tip-top(899552d6) and ba36899 booted just fine for me. I
>> > noticed something, you must have commits on top of your ba36899? Mine
>> > shows 3.16.0-11149-gba36899.
>>
>> Ok, thanks for info. I went back to 3.16, and it worked in same
>> config, and went to 3.17, and it broke.
>
> The problem is still there in 3.17-rc2. 3.16 does not have the
> problem. Messages are still similar:
>
> mmc0: new high speed SDHC card at address b368
> mmcblk0: mmc0:b368 USD   7.45 GiB
>  mmcblk0: p1 p2 p3 p4
> VFS: Cannot open root device "mmcblk0p2" or unknown-block(0,0): error
> -6
> Please append a correct "root=" boot option; here are the available
> partitions:
> b300         7822336 mmcblk0  driver: mmcblk
>   b301          102400 mmcblk0p1 00082434-01
>   b302         1048576 mmcblk0p2 00082434-02
>   b303            1024 mmcblk0p3 00082434-03
>   b304         6086656 mmcblk0p4 00082434-04
> Kernel panic - not syncing: VFS: Unable to mount root fs on unknown-block(0,0)
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted
> 3.17.0-rc2-00368-gec0400b-dirty #83
>
>
> What is going on there? Clearly partition table was parsed and
> partitions are available; does the mention of unknown-block(0,0) mean
> that kernel failed to parse the command line?
>
> I replaced "root=/dev/mmcblk0p2" with "root=b302" and have a booting
> system.


Can you do a bisect? 3.17-rc2 booted fine for me today:

EXT3-fs (mmcblk0p2): mounted filesystem with ordered data mode
VFS: Mounted root (ext3 filesystem) on device 179:2.
Freeing unused kernel memory: 252K (c052d000 - c056c000)
random: nonblocking pool is initialized

Poky 8.0 (Yocto Project 1.3 Reference Distro) 1.3 socfpga_cyclone5 ttyS0

socfpga_cyclone5 login: root
root@socfpga_cyclone5:~# uname -a
Linux socfpga_cyclone5 3.17.0-rc2-00006-gdd7ad78 #1 SMP Tue Aug 26
15:51:56 CDT 2014 armv7l GNU/Linux

Dinh
