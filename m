Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbaCDL60 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:58:26 -0500
Received: from mail-ea0-f179.google.com ([209.85.215.179]:40983 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaCDL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:58:24 -0500
Date: Tue, 04 Mar 2014 12:58:21 +0100
From: Christian Riesch <christian.riesch@omicron.at>
To: linux-mtd@lists.infradead.org
cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        linux-kernel@vger.kernel.org, Amul Kumar Saha <amul.saha@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Brian Norris <computersforpeace@gmail.com>
Subject: Re: [PATCH v2 RESEND 0/2] mtd: Harmonize implementations of OTP
 write and _get_{fact, user}_prot_info
Message-ID: <10DBE6208E782E524598F837@[172.22.2.41]>
In-Reply-To: <acc2341a-fbbe-4508-a8e0-00e94a28d01c@mary.at.omicron.at>
References: <acc2341a-fbbe-4508-a8e0-00e94a28d01c@mary.at.omicron.at>
X-Mailer: Mulberry/4.0.8 (Win32)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

--On January 28, 2014 09:29 +0100 Christian Riesch 
<christian.riesch@omicron.at> wrote:

> Hi all,
>
> In the discussion on my patchset for the OTP support for
> drivers/mtd/chips/cfi_cmdset_0002.c [1-5], Artem requested two changes in
> the current code of the OTP write functions and the
> _get_{fact,user}_prot_info code.
>
> These two patches are an attempt to make the requested changes.
>
> The first patch adds a retlen parameter to the _get_fact_prot_info and
> _get_user_prot_info functions and thus harmonizes the implementation
> with those of the write and read functions.
>
> The second patch fixes a problem that I earlier addressed in [1]. After
> the discussion about this patch on the mtd mailing list, I think that the
> correct behavior of the write function should be the one specified in [6]:
> Try to write as many bytes as possible and return the number of bytes
> that were written. If no data could be written due to lack of OTP memory,
> return -ENOSPC.
>
> Artem, would you please have a look at these patches? I would like to know
> if I understood you correctly, or if I missed something here. Please note
> that I cannot test these patches since I do not have the hardware. The
> patches are compile tested only. If these patches are ok, I will also
> respin the OTP support patches for cfi_cmdset_0002.
>

Sorry for bugging you (Artem, mtd Maintainers) again, but I would really 
like to get this patchset ([a], [b]) and the OTP support for 
cfi_cmdset_0002.c into mainline. Please have a look at the patches and just 
tell me if the changes in them are acceptable, or if I should rather post 
the OTP support without these two patches. Once I have your answer, I will 
respin these patches and my OTP patches, test them again, and submit them. 
But without your help I cannot continue.

[a] http://patchwork.ozlabs.org/patch/314624/
[b] http://patchwork.ozlabs.org/patch/314625/

Thank you very much!

Christian

> Changes for v2:
> - Fixed buggy cfi_intelext_get_fact_prot_info
>
> Thank you!
>
> Best regards,
> Christian
>
> [1] http://patchwork.ozlabs.org/patch/239897/
> [2] http://patchwork.ozlabs.org/patch/240010/
> [3] http://patchwork.ozlabs.org/patch/240007/
> [4] http://patchwork.ozlabs.org/patch/240008/
> [5] http://patchwork.ozlabs.org/patch/240009/
> [6] http://pubs.opengroup.org/onlinepubs/9699919799/functions/write.html
>
> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Amul Kumar Saha <amul.saha@samsung.com>
> Cc: Brian Norris <computersforpeace@gmail.com>
>
> Christian Riesch (2):
>   mtd: Add a retlen parameter to _get_{fact,user}_prot_info
>   mtd: Fix the behavior of otp write if there is not enough room for
>     data
>
>  drivers/mtd/chips/cfi_cmdset_0001.c |   44
> +++++++++++++++++++----------------  drivers/mtd/devices/mtd_dataflash.c
> |   20 +++++++---------
>  drivers/mtd/mtdchar.c               |   18 ++++++++++----
>  drivers/mtd/mtdcore.c               |   12 +++++-----
>  drivers/mtd/mtdpart.c               |   14 ++++++-----
>  drivers/mtd/onenand/onenand_base.c  |   40
> ++++++++++++++++---------------  include/linux/mtd/mtd.h             |
> 16 ++++++-------
>  7 files changed, 89 insertions(+), 75 deletions(-)
>
> --
> 1.7.9.5
>
>
> ______________________________________________________
> Linux MTD discussion mailing list
> http://lists.infradead.org/mailman/listinfo/linux-mtd/




