Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948AbaKGLJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:09:25 -0500
Received: from mga14.intel.com ([192.55.52.115]:25205 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaKGLJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:09:23 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="618786642"
Message-ID: <1415358434.14686.119.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [LKP] [dmi] PANIC: early exception 0e rip 10:ffffffff81899e6b
 error 9 cr2 ffffffffff240000
From: Matt Fleming <matt.fleming@intel.com>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKP <lkp@01.org>,
        "Leif Lindholm" <leif.lindholm@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 7 Nov 2014 11:07:14 +0000
In-Reply-To: <20141107093031.GF24745@yliu-dev.sh.intel.com>
References: <20141107054741.GB30507@yliu-dev.sh.intel.com>
	 <CAKv+Gu9_ipZe-BV_CxhYVdv2mPrab3EXdznJUd-Unbw3usmckw@mail.gmail.com>
	 <1415351762.14686.99.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20141107093031.GF24745@yliu-dev.sh.intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [163.33.239.182]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 17:30 +0800, Yuanhan Liu wrote:
> 
> 
> The address changes to 10:ffffffff8167aa1a, and in the System.map, it has:
> 
>   ffffffff8167a9d0 t dmi_table
>   ffffffff8167aac0 T dmi_name_in_vendors
> 
> Sorry, I don't know how to dig furture.

Could you build a kernel without Ard's u32 cast fix and do,

objdump -dr vmlinux > /tmp/1

Then apply Ard's u32 cast fix, and rebuild the kernel and do,

objdump -dr vmlinux > /tmp/2

Then send me the output of,

diff -u /tmp/1 /tmp/2

