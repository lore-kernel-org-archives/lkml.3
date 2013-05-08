Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255Ab3EHOda (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:33:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40247 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756079Ab3EHOd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:33:29 -0400
Date: Wed, 8 May 2013 16:34:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: ipc/shm.c:494:18: warning: =?utf-8?Q?unuse?=
 =?utf-8?B?ZCB2YXJpYWJsZSDigJhoc+KAmQ==?= [-Wunused-variable]
Message-ID: <20130508143411.GD30955@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

looks like this warning came in with
af73e4d9506d3b797509f3c030e7dcd554f7d9c4 and fires in the

# CONFIG_HUGETLB_PAGE is not set

case because

	struct hstate *hs = hstate_sizelog((shmflg >> SHM_HUGE_SHIFT)
                                        & SHM_HUGE_MASK);

becomes

	struct hstate *hs = ((void *)0)

due to

#define hstate_sizelog(s) NULL

Hmmm, I don't have a quick solution off the top of my head from staring
at the code.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
