Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755215AbaDKFNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 01:13:14 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:50630 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbaDKFNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 01:13:12 -0400
MIME-Version: 1.0
Date: Thu, 10 Apr 2014 22:13:11 -0700
Message-ID: <CADU+-uBr9UctHt1crnYAjYm5uNYmva2KDh5BZyZtkRG9_Xm-ag@mail.gmail.com>
Subject: aic94xx: maybe uninitialized variable in asd_process_ctrl_a_user
From: Filipe Brandenburger <filbranden@google.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michel Lespinasse <walken@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

While building a recent kernel with -Werror I found this warning:

drivers/scsi/aic94xx/aic94xx_sds.c: In function 'asd_read_flash':
drivers/scsi/aic94xx/aic94xx_sds.c:597:21: error: 'offs' may be used
uninitialized in this function [-Werror=maybe-uninitialized]
drivers/scsi/aic94xx/aic94xx_sds.c:985:6: note: 'offs' was declared here

This looks like a valid complaint from the compiler, since in
asd_process_ctrl_a_user if the call to asd_find_flash_de fails (and
returns -ENOENT) then offs will not be set, but that will not prevent
the variable to be later passed to the call to asd_read_flash_seg
later in that same function.

Would you please have a look at it? Let me know if there's a more
appropriate way to report these issues (e.g. bug tracker.)

Thanks,
Filipe
