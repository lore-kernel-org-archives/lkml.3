Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaKGJiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:38:07 -0500
Received: from mga14.intel.com ([192.55.52.115]:33186 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbaKGJiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:38:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="618754809"
Message-ID: <1415352966.14686.101.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Matt Fleming <matt.fleming@intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKP <lkp@01.org>,
        "Leif Lindholm" <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2014 09:36:06 +0000
In-Reply-To: <20141107092651.GE24745@yliu-dev.sh.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	 <CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
	 <20141107073720.GB24745@yliu-dev.sh.intel.com>
	 <CAKv+Gu-rRMmcP4LF3oo5=6hf8m7fjzkzV14hfkjBPbPn34OZGA@mail.gmail.com>
	 <20141107081344.GC24745@yliu-dev.sh.intel.com>
	 <CAKv+Gu9u5ojSWarm2A5MeWOj1r1+W8U0d+icnx2rfAmiSaL8Ww@mail.gmail.com>
	 <20141107084604.GD24745@yliu-dev.sh.intel.com>
	 <CAKv+Gu_Xx9aKzNU2CfP20WR1ojwjUEvTKyD7L-S9bR_C8EOogQ@mail.gmail.com>
	 <20141107092651.GE24745@yliu-dev.sh.intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.181]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 17:26 +0800, Yuanhan Liu wrote:
> 
> Here is the output:
> 
> [    0.000000] NX (Execute Disable) protection: active
> [    0.000000] ====== Decoding _DMI_ header:
> [    0.000000] 5f 44 4d 49 5f 48 a3 0b 00 20 60 8f 3e 00 25 00 
> [    0.000000] ====== Remapped SMBIOS table 0xffffffff8f602000 at ffffffffff240000, size 0xba3, num 0x3e

Smells like a sign extension issue. Previously how could dmi_base (u32)
hold 0xffffffff8f602000?

