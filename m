Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491AbaCXPeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 11:34:20 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:50175 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbaCXPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 11:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140321130917.GA8667@localhost>
References: <532c2aaa.lXHUJ9RIRCRIxqPO%fengguang.wu@intel.com>
	<20140321130917.GA8667@localhost>
Date: Mon, 24 Mar 2014 16:34:17 +0100
Message-ID: <CA+MoWDrGGE4X9aX0=_iaacXUar17fb1B+CR5VcsPAwLFFiPCCA@mail.gmail.com>
Subject: Fwd: cx23885-dvb.c:undefined reference to `tda18271_attach'
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux-media <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kbuild-all@01.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm being blamed for some bugs for more than one year, and this
weekend I was able to reproduce the error for the first time. I have
the impression that the issue is related to Kconfig because when
compiling the Kernel for x86(not x86_64), and
when:
CONFIG_VIDEO_CX23885=y

and

CONFIG_MEDIA_TUNER_TDA18271=m

the build fails as the tuner code was compiled as a module when it
should have been compiled as part of the Kernel. On the Kconfig file
drivers/media/pci/cx23885/Kconfig:
config VIDEO_CX23885
        tristate "Conexant cx23885 (2388x successor) support"
        ...
        select MEDIA_TUNER_TDA18271 if MEDIA_SUBDRV_AUTOSELECT

which I think is the problem. Can I just remove this 'if
MEDIA_SUBDRV_AUTOSELECT'? Or what is the correct way of telling
Kconfig to set CONFIG_MEDIA_TUNER_TDA18271 based on the value of
CONFIG_VIDEO_CX23885?

There are at least 6 similar cases which I'm willing to send patches.

Thank you,

Peter
