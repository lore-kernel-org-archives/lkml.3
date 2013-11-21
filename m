Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab3KUKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:12:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41946 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913Ab3KUKMm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:12:42 -0500
Date: Thu, 21 Nov 2013 11:12:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Francis Moreau <francis.moro@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Wei WANG <wei_wang@realsil.com.cn>, Chris Ball <cjb@laptop.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: Re: 3.12: kernel panic when resuming from suspend to RAM (x86_64)
Message-ID: <20131121101234.GB25459@pd.tnic>
References: <20131117195358.GO27323@pd.tnic>
 <CAC9WiBggfssh+31_MqVCT-hDf2E8zTuc81q-DhLYQuVF053mEA@mail.gmail.com>
 <20131117220611.GQ27323@pd.tnic>
 <528A05D0.30907@gmail.com>
 <20131118133210.GG24851@pd.tnic>
 <528B36EA.20301@gmail.com>
 <20131119101521.GA3515@pd.tnic>
 <528C84A1.5030707@gmail.com>
 <20131120111541.GA30147@pd.tnic>
 <528DC2AA.4070202@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <528DC2AA.4070202@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 09:22:02AM +0100, Francis Moreau wrote:
> Hmm, I think it's more than that because if I'm removing both
> rtsx_pci_ms and memstick modules, then suspending and resuming doesn't
> oops anymore.

Interesting - so this is a good datapoint. Sounds like those modules
can't stomach suspend-to-ram. So let's add a couple more people for
comment.

To the newly-CCed, guys, thread starts here:

http://marc.info/?l=linux-kernel&m=138468134321335

> Also I took a look at the changes between v3.11 and v3.12 in this area
> and those changes match the issue I'm facing:
> 
> $ git log --oneline v3.11..v3.12 -- drivers/mfd/rtsx_pcr.c
> 09fd867 mfd: rtsx: Copyright modifications
> eb891c6 mfd: rtsx: Configure to enter a deeper power-saving mode in S3
> 7140812 mfd: rtsx: Move some actions from rtsx_pci_init_hw to individual
> extra_init_hw
> 5947c16 mfd: rtsx: Add shutdown callback in rtsx_pci_driver
> 773ccdf mfd: rtsx: Read vendor setting from config space
> 
> I'll try to bisect one more time those changes tonight to see if I can
> find out if one of those commits is the culprit.

Good idea.

> Sorry for not answering the first time, but yes my bios is uptodate.

Ok, good.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
