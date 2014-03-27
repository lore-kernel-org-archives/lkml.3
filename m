Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbaC0WCW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 18:02:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48511 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755185AbaC0WCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 18:02:21 -0400
Date: Thu, 27 Mar 2014 15:02:15 -0700
From: Michal Hocko <mhocko@suse.cz>
To: Celestino Martinez Lopez <celestino.martinez.lopez@ericsson.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Kernel oops without Backtrace
Message-ID: <20140327220215.GB30232@dhcp22.suse.cz>
References: <79ECA39DE9A8974383B3B752D91CED3219E13C35@ESESSMB107.ericsson.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79ECA39DE9A8974383B3B752D91CED3219E13C35@ESESSMB107.ericsson.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 27-03-14 13:47:21, Celestino Martinez Lopez wrote:
> Hi All,
> 
> I am running a SUSE linux 3.0.13-0.27 and after printing an opps the system hangs (though it only happened once).
> In the opps there is only Code: information, no stack trace or processor registers.
> Analyzing the code most of the cores are in intel_idle function, but there is also appears native_read_tsc and delay_tsc.
> 
> Any help would be more than welcome.

http://bugzilla.novell.com/ would be a more appropriate channel IMO.

> Attached the console output:
> 
> [2718229.308036] Stack:
> [2718229.334021] Call Trace:
> [2718229.365203] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.592831] Stack:
> [2718229.618815] Call Trace:
> [2718229.619910] Leftover inexact backtrace:
> [2718229.619910]
> [2718229.619911]  <IRQ>
> [2718229.619913]  <EOI>
> [2718229.619914] Code: 98 45 89 ef 48 89 04 24 eb 16 66 0f 1f 44 00 00 f3 90 65 44 8b 34 25 70 c5 00 00 45 39 fe 75 2b 66 66 90 0f
> ae e8 e8 cd 9a db ff
> [2718229.620741] Stack:
> [2718229.620748] Call Trace:
> [2718229.620761] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.620825] Stack:
> [2718229.620833] Call Trace:
> [2718229.620842] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.621012] Stack:
> [2718229.621020] Call Trace:
> [2718229.621036] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.621115] Stack:
> [2718229.621122] Call Trace:
> [2718229.621132] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.621205] Stack:
> [2718229.621212] Call Trace:
> [2718229.621222] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.621422] Stack:
> [2718229.621429] Call Trace:
> [2718229.621446] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [2718229.621551] Stack:
> [2718229.621564] Call Trace:
> [2718229.621579] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194339.646298] Stack:
> [4194339.672279] Call Trace:
> [4194339.704539] Leftover inexact backtrace:
> [4194339.704539]
> [4194339.772037]  <IRQ>
> [4194339.796922]  <EOI>
> [4194339.826073] Code: 70 e4 71 c3 0f 1f 80 00 00 00 00 40 0f b6 c6 e6 70 40 0f b6 c7 e6 71 c3 0f 1f 00 0f 31 89 c1 48 89 d0 48 c1
> e0 20 89 ca 48 09 d0 <c3> 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 48 83 ec 18 48
> [4194340.054808] Stack:
> [4194340.080786] Call Trace:
> [4194340.111957] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194340.339554] Stack:
> [4194340.365534] Call Trace:
> [4194340.396700] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194340.624288] Stack:
> [4194340.650267] Call Trace:
> [4194340.681435] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194340.909073] Stack:
> [4194340.935054] Call Trace:
> [4194340.966222] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194341.193816] Stack:
> [4194341.219796] Call Trace:
> [4194341.250969] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194341.478549] Stack:
> [4194341.504530] Call Trace:
> [4194341.535696] Code: 01 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 48 8d 74 24 2c bf
> [4194341.763335] Stack:
> BIOS Date: 12/27/10 16:47 e8 5d 41 5c c3 0f 1f 40 00 31 c9 48 89 f0 48 89 ca 0f 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0         621551] Stack:
> 
> 
> Press Ctrl+S to enter the Setup Menu..
> Press Ctrl+S to enter the Setup Menu.
> 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0
> Copyright(c) 2011 LSI Corporation
> PCI SLOT ID  LUN VENDOR    PRODUCT                       REVISION CAPACITY
> 1            0   LSI       Virtual Drive                 RAID1    285148MB     01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0Initia<Ctrl><H> for WebBIOS or press <Ctrl><Y> for Preboot CLI
> PXE 2.1 Build 086 (WfM 2.0)                                                     01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0                                                          REVISION
> CAPACITY
> nd on the host adapter.
> Auto-detecting USB Mass Storage Devices ..
> s fo
> 
> CPU : Intel(R) Xeon(R) CPU           X                                          01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0QPI Operational Speed
> b6 c7 e6 71 c3 0f 1f 00 0f 31 89 c1 48 89 d0 48 c1
> e0 20 89 ca 48 09 d0 <c3> 66 66 66 66 66 66 2e 0f 1f 84 00 00 00 0                                   8.00.16
> 01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e
> 0f 1f 84 00 00 00 00 0
> tializing USB Controllers .. Done.
> 008F
> 95 Watts
> Press any key to continue.
> Press any key to continue.                          95 Watts
> Press any key to continue.         8.00.16                                      01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0Press any key to continue.
> Press any key to continue.
> Press any key to continue.
> Press any key to continue.                                                      01 c8 0f ae f0 48 8b 87 38 e0 ff ff a8 08 75 88 b1
> 01 48 89 e8 0f 01 c9 <e9> 7b ff ff ff 66 2e 0f 1f 84 00 00 00 00 0Press any key to continue.
> Press any key to continue.
> Press any key to continue.
> 
> GNU GRUB  version 0.97  (613K lower / 2087424K upper memory)
> 
> +-------------------------------------------------------------------------+
> Use the ^ and v keys to select which entry is highlighted.
> Press enter to boot the selected OS, 'e' to edit the
> |                                                                         |
> |                                                                         |
> | SUSE Linux Enterprise Server 11 SP2 - 3.0.13-0.27                       |
> Booting 'SUSE Linux Enterprise Server 11 SP2 - 3.0.13-0.27'
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Michal Hocko
SUSE Labs
