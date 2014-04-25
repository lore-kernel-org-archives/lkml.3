Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916AbaDYVUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 17:20:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:25937 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751156AbaDYVUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 17:20:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,929,1389772800"; 
   d="scan'208";a="528567749"
Message-ID: <535AD19D.8000502@linux.intel.com>
Date: Fri, 25 Apr 2014 14:20:29 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Andy Lutomirski <amluto@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        Brian Gerst <brgerst@gmail.com>,
        Alexandre Julliard <julliard@winehq.com>,
        Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86-64: espfix for 64-bit mode *PROTOTYPE*
References: <tip-kicdm89kzw9lldryb1br9od0@git.kernel.org> <1398120472-6190-1-git-send-email-hpa@linux.intel.com> <20140425120229.GA4691@amd.pavel.ucw.cz>
In-Reply-To: <20140425120229.GA4691@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 05:02 AM, Pavel Machek wrote:
> 
> Just to understand the consequences -- we leak 16 bit of kernel data
> to the userspace, right? Because it is %esp, we know that we leak
> stack address, which is not too sensitive, but will make kernel
> address randomization less useful...?
> 

It is rather sensitive, in fact.

>> The 64-bit implementation works like this:
>>
>> Set up a ministack for each CPU, which is then mapped 65536 times
>> using the page tables.  This implementation uses the second-to-last
>> PGD slot for this; with a 64-byte espfix stack this is sufficient for
>> 2^18 CPUs (currently we support a max of 2^13 CPUs.)
> 
> 16-bit stack segments on 64-bit machine. Who still uses it? Dosemu?
> Wine? Would the solution be to disallow that?

Welcome to the show.  We do, in fact disallow it now in the 3.15-rc
series.  The Wine guys are complaining.

	-hpa


