Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594AbaE0Wx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 18:53:57 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38614 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaE0Wx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 18:53:56 -0400
MIME-Version: 1.0
In-Reply-To: <5384d07e.4504e00a.2680.ffff8c31SMTPIN_ADDED_BROKEN@mx.google.com>
References: <cover.1400607328.git.tony.luck@intel.com>
	<eb791998a8ada97b204dddf2719a359149e9ae31.1400607328.git.tony.luck@intel.com>
	<20140523033438.GC16945@gchen.bj.intel.com>
	<CA+8MBb+Una+Z5Q-Pn0OoMYaaSx9sPJ3fdriMRMgN=CE1Jdp7Cg@mail.gmail.com>
	<20140527161613.GC4108@mcs.anl.gov>
	<5384d07e.4504e00a.2680.ffff8c31SMTPIN_ADDED_BROKEN@mx.google.com>
Date: Tue, 27 May 2014 15:53:55 -0700
Message-ID: <CA+8MBbKuBo4c2v-Y0TOk-LUJuyJsGG=twqQyAPG5WOa8Aj4GyA@mail.gmail.com>
Subject: Re: [PATCH 1/2] memory-failure: Send right signal code to correct thread
From: Tony Luck <tony.luck@gmail.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Kamil Iskra <iskra@mcs.anl.gov>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>, Borislav Petkov <bp@suse.de>,
        Chen Gong <gong.chen@linux.jf.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - make sure that every thread in a recovery aware application should have
>    a SIGBUS handler, inside which
>    * code for SIGBUS(BUS_MCEERR_AR) is enabled for every thread
>    * code for SIGBUS(BUS_MCEERR_AO) is enabled only for a dedicated thread

But how does the kernel know which is the special thread that
should see the "AO" signal?  Broadcasting the signal to all
threads seems to be just as likely to cause problems to
an application as the h/w broadcasting MCE to all processors.

-Tony
