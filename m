Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbaIARfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 13:35:30 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:55439 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784AbaIARf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 13:35:26 -0400
Date: Mon, 1 Sep 2014 10:35:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: Tree for Aug 29
Message-ID: <20140901173521.GA8259@roeck-us.net>
References: <20140829150713.50d78c30@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140829150713.50d78c30@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 03:07:13PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> I will be on vacation for the next week, so the next linux-next that I
> will release will be next-20140908.  Sorry for the inconvenience.
> 
> Changes since 20140828:
> 
> The staging tree still had its build failure for which I applied a
> fix patch.
> 
> Non-merge commits (relative to Linus' tree): 2327
>  2465 files changed, 66838 insertions(+), 40620 deletions(-)
> 
> ----------------------------------------------------------------------------
> 
ia64:defconfig is broken with this build and results in the following error
message.

arch/ia64/sn/kernel/setup.c: In function 'sn_cpu_init':
arch/ia64/sn/kernel/setup.c:632:13: error: lvalue required as left operand of assignment
make[1]: *** [arch/ia64/sn/kernel/setup.o] Error 1
make: *** [arch/ia64/sn/kernel/setup.o] Error 2

bisect points to commit 6065a244a039 ('ia64: Replace __get_cpu_var uses').

$ git bisect log
# bad: [d7cf2b3139909a354a71e2885c942e21a60ea062] Add linux-next specific files for 20140829
# good: [52addcf9d6669fa439387610bc65c92fa0980cef] Linux 3.17-rc2
git bisect start 'HEAD' 'v3.17-rc2'
# good: [a065408138b1e9876a95c30153087617e9ef56df] Merge remote-tracking branch 'crypto/master'
git bisect good a065408138b1e9876a95c30153087617e9ef56df
# good: [8032bd58d53bf68cc618ed3c945654d495a3381e] Merge remote-tracking branch 'xen-tip/linux-next'
git bisect good 8032bd58d53bf68cc618ed3c945654d495a3381e
# bad: [937c09a4fafaa87793584723a9c78070ba1313c7] Merge remote-tracking branch 'staging/staging-next'
git bisect bad 937c09a4fafaa87793584723a9c78070ba1313c7
# good: [09d6dd7490ee7f1dda926e309df370e28679a71c] staging: comedi: 8255: add a comedi_device param to the (*io) callback
git bisect good 09d6dd7490ee7f1dda926e309df370e28679a71c
# bad: [436011f94749fe990ca1fafbdb28d5dc4abe9120] Merge remote-tracking branch 'regmap/for-next'
git bisect bad 436011f94749fe990ca1fafbdb28d5dc4abe9120
# bad: [0b3fd10cf0cda8f319eae27adffb8b7a45431702] Merge remote-tracking branch 'workqueues/for-next'
git bisect bad 0b3fd10cf0cda8f319eae27adffb8b7a45431702
# bad: [6065a244a039a23d933e4b803a4e052da2849208] ia64: Replace __get_cpu_var uses
git bisect bad 6065a244a039a23d933e4b803a4e052da2849208
# good: [903ceff7ca7b4d80c083a80ee5163b74e9fa359f] net: Replace get_cpu_var through this_cpu_ptr
git bisect good 903ceff7ca7b4d80c083a80ee5163b74e9fa359f
# good: [e16321709c8270f9803bbfdb51e5e02235078c7f] uv: Replace __get_cpu_var
git bisect good e16321709c8270f9803bbfdb51e5e02235078c7f
# good: [35898716b4d3382791d219be317faace580b6a41] mips: Replace __get_cpu_var uses
git bisect good 35898716b4d3382791d219be317faace580b6a41
# good: [0bf7fcf155160fd483af7ffdc50efd4be96f1c96] s390: cio driver &__get_cpu_var replacements
git bisect good 0bf7fcf155160fd483af7ffdc50efd4be96f1c96
# first bad commit: [6065a244a039a23d933e4b803a4e052da2849208] ia64: Replace __get_cpu_var uses

Reverting the bad commit fixes the problem.

Guenter
