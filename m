Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751314AbaLOV3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 16:29:36 -0500
Received: from mail-db3on0099.outbound.protection.outlook.com ([157.55.234.99]:38528
	"EHLO emea01-db3-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751035AbaLOV3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 16:29:34 -0500
X-Greylist: delayed 17515 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Dec 2014 16:29:34 EST
Message-ID: <548F52AA.7060207@ezchip.com>
Date: Mon, 15 Dec 2014 16:29:14 -0500
From: Chris Metcalf <cmetcalf@ezchip.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] arch/tile changes for 3.19
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [12.216.194.146]
X-ClientProxiedBy: BLUPR07CA0104.namprd07.prod.outlook.com (10.255.223.175) To
 AM3PR02MB0535.eurprd02.prod.outlook.com (25.160.6.141)
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0535;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601003);SRVR:AM3PR02MB0535;
X-Forefront-PRVS: 04267075BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(6049001)(6009001)(189002)(199003)(65956001)(107886001)(65806001)(36756003)(106356001)(120916001)(107046002)(59896002)(4396001)(66066001)(64706001)(20776003)(101416001)(47776003)(33656002)(86362001)(50986999)(87266999)(65816999)(23756003)(54356999)(229853001)(46102003)(99396003)(31966008)(122386002)(64126003)(87976001)(50466002)(15975445007)(77096005)(68736005)(83506001)(42186005)(21056001)(80316001)(92566001)(19580405001)(62966003)(19580395003)(97736003)(77156002)(40100003)(105586002)(18886065003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM3PR02MB0535;H:[10.7.0.239];FPR:;SPF:None;MLV:nov;PTR:InfoNoRecords;MX:1;A:1;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:AM3PR02MB0535;
X-OriginatorOrg: ezchip.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Dec 2014 21:29:26.1000 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM3PR02MB0535
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the following changes for 3.19 from:

   git://git.kernel.org/pub/scm/linux/kernel/git/cmetcalf/linux-tile.git master

Note that one of the changes converts my old cmetcalf@tilera.com email in
MAINTAINERS to the cmetcalf@ezchip.com email that you see on this email.

Chen Gang (3):
       arch: tile: kernel: signal.c: Use __copy_from/to_user() instead of __get/put_user()
       arch: tile: gxio: Export symbols for module using in 'mpipe.c'
       arch: tile: kernel: kgdb.c: Use memcpy() instead of pointer copy one by one

Chris Metcalf (2):
       tile: avoid undefined behavior with regs[TREG_TP] etc
       arch/tile: update MAINTAINERS email to EZchip

Joe Perches (1):
       tile: Use the more common pr_warn instead of pr_warning

  MAINTAINERS                             |  2 +-
  arch/tile/gxio/mpipe.c                  |  4 ++
  arch/tile/include/asm/io.h              |  5 +-
  arch/tile/include/asm/pgtable.h         |  4 +-
  arch/tile/include/asm/pgtable_64.h      |  2 +-
  arch/tile/include/uapi/asm/ptrace.h     | 16 +++---
  arch/tile/include/uapi/asm/sigcontext.h | 14 +++--
  arch/tile/kernel/hardwall.c             |  6 +--
  arch/tile/kernel/irq.c                  |  5 +-
  arch/tile/kernel/kgdb.c                 |  6 +--
  arch/tile/kernel/kprobes.c              |  3 +-
  arch/tile/kernel/machine_kexec.c        | 28 ++++------
  arch/tile/kernel/messaging.c            |  5 +-
  arch/tile/kernel/module.c               | 12 ++---
  arch/tile/kernel/pci.c                  |  7 ++-
  arch/tile/kernel/pci_gx.c               | 95 ++++++++++++++-------------------
  arch/tile/kernel/process.c              | 16 +++---
  arch/tile/kernel/setup.c                | 36 ++++++-------
  arch/tile/kernel/signal.c               | 20 ++-----
  arch/tile/kernel/single_step.c          |  6 +--
  arch/tile/kernel/smpboot.c              |  5 +-
  arch/tile/kernel/stack.c                |  7 +--
  arch/tile/kernel/time.c                 |  4 +-
  arch/tile/kernel/traps.c                | 10 ++--
  arch/tile/kernel/unaligned.c            | 22 ++++----
  arch/tile/mm/fault.c                    | 34 ++++++------
  arch/tile/mm/homecache.c                |  6 +--
  arch/tile/mm/hugetlbpage.c              | 18 +++----
  arch/tile/mm/init.c                     | 32 +++++------
  arch/tile/mm/pgtable.c                  |  4 +-
  30 files changed, 187 insertions(+), 247 deletions(-)

-- 
Chris Metcalf, EZChip Semiconductor
http://www.ezchip.com
