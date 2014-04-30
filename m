Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbaD3QSw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:18:52 -0400
Received: from mga01.intel.com ([192.55.52.88]:17712 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759347AbaD3QSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:18:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,959,1389772800"; 
   d="scan'208";a="531394635"
Message-ID: <5361224C.80702@linux.intel.com>
Date: Wed, 30 Apr 2014 09:18:20 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Lutomriski <amluto@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH] x86-64, espfix: Don't leak bits 31:16 of %esp returning
 to 16-bit stack
References: <1398816946-3351-1-git-send-email-hpa@linux.intel.com> <20140430103822.GD23736@pd.tnic>
In-Reply-To: <20140430103822.GD23736@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2014 03:38 AM, Borislav Petkov wrote:
> 
> What will happen more likely and thus more often - our "simulated" #DF
> or a real one? Judging by the order of the tests, you're saying: the
> simulated one. :-)
> 
> Otherwise, push the __KERNEL_CS test up?
> 

Doesn't matter, really: do_double_fault is unconditionally fatal.

	-hpa


