Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaBSTMF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 14:12:05 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:40900 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754367AbaBSTMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 14:12:03 -0500
Message-ID: <530501A7.2030703@ti.com>
Date: Wed, 19 Feb 2014 11:10:31 -0800
From: Russ Dill <Russ.Dill@ti.com>
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Capella <sebastian.capella@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Russell King <linux@arm.linux.org.uk>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Nicolas Pitre <nico@linaro.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <Will.Deacon@arm.com>,
        Jonathan Austin <Jonathan.Austin@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH RFC v1 3/3] ARM hibernation / suspend-to-disk
References: <1392774729-3235-1-git-send-email-sebastian.capella@linaro.org> <1392774729-3235-4-git-send-email-sebastian.capella@linaro.org> <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
In-Reply-To: <20140219161254.GB19343@e102568-lin.cambridge.arm.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/19/2014 08:12 AM, Lorenzo Pieralisi wrote:

+ *  https://patchwork.kernel.org/patch/96442/


I think the idea here is to get the CPU into a state so that later
when we resume from the resume kernel, the actual CPU state matches
the state we have in kernel. The main thing flush_thread does is clear
out any and all FP state.

The may be part of the patchset that is OBE.



cpu_resume makes many assumptions about the state of the state of the
CPU, the primary being that the MMU is disabled, but also that all
caches and IRQs are disabled. soft_restart does all this for us.



ah, you are saying just return from __swsusp_arch_save_image and allow
cpu_suspend_abort to be called, placing the result of swsusp_save
somewhere else. This may work and would reduce the complexity of the
code slightly.



This is taken from the previous iteration of the patchset, I think the
comment is OBE.



But this is still required to select the right mapping for our copying.



I don't remember why I needed to prevent gcc from manipulating the
stack here.



This is another holdover from previous patch versions that may be OBE.



-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlMFAaYACgkQfNRrxBinbdsWTwCgowSU7VPqGcM4ks39FtAihsBe
vfYAn3gxZEu753xyESuye0y1z+wbWJRp
=JZ1s
-----END PGP SIGNATURE-----
