Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3KLAEU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 19:04:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:60471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369Ab3KLAEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 19:04:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407146160"
Message-ID: <5281707D.1040604@linux.intel.com>
Date: Mon, 11 Nov 2013 16:04:13 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Corrupted low memory in v3.9+
References: <CAOesGMgV2UsBffPveaE+j1s-mDZ+cQvvQGLGAXjWSAv+a_56Fw@mail.gmail.com> <52603CD6.6080507@linux.intel.com> <CAOesGMjgvPWpZssrepDszTr0EexHtDXznWA4XYoZ6O_U=XJGAg@mail.gmail.com> <CAOesGMgiUbJF01+BPBDgJT3J-Sn6ewE04aMyCTYrwjKwY4S2SQ@mail.gmail.com> <527BEA91.6050603@linux.intel.com> <20131111113503.GA16090@gmail.com> <528168CB.7070602@linux.intel.com>
In-Reply-To: <528168CB.7070602@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 03:31 PM, H. Peter Anvin wrote:
> On 11/11/2013 03:35 AM, Ingo Molnar wrote:
> 
> Oops!  I had misunderstood how the checker worked -- I thought it
> checked the *reserved* memory, but it in fact reserves memory
> *independently* and then checks it.
> 

And now I understand why I had that misconception:

> 	  Periodically check for memory corruption in low memory, which
> 	  is suspected to be caused by BIOS.  Even when enabled in the
> 	  configuration, it is disabled at runtime.  Enable it by
> 	  setting "memory_corruption_check=1" on the kernel command
> 	  line.  By default it scans the low 64k of memory every 60
> 	  seconds; see the memory_corruption_check_size and
> 	  memory_corruption_check_period parameters in
> 	  Documentation/kernel-parameters.txt to adjust this.

This makes it sound like it scans the low 64K when it is turned on, i.e.
the bit that is reserved by default.

I think we should change that default too to 640K.  I will post a
patchset shortly.

	-hpa



