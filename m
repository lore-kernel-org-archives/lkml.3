Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab3DLR4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 13:56:38 -0400
Received: from mga09.intel.com ([134.134.136.24]:38090 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3DLR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 13:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,464,1363158000"; 
   d="scan'208";a="317361288"
Message-ID: <51684AD3.7090305@linux.intel.com>
Date: Fri, 12 Apr 2013 10:56:35 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu, Kevin Hilman <khilman@linaro.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH documentation 1/2] nohz1: Add documentation.
References: <20130411160524.GA30384@linux.vnet.ibm.com> <1365696359-30958-1-git-send-email-paulmck@linux.vnet.ibm.com> <20130411182502.GA31684@pd.tnic> <20130411191355.GO29861@linux.vnet.ibm.com> <1365753904.17140.22.camel@laptop> <20130412175419.GG29861@linux.vnet.ibm.com>
In-Reply-To: <20130412175419.GG29861@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ------------------------------------------------------------------------
>
> 1.	It increases the number of instructions executed on the path
> 	to and from the idle loop.
>
> 2.	On many architectures, dyntick-idle mode also increases the
> 	number of times that clocks must be reprogrammed, and this
> 	reprogramming can be quite expensive.


it's really that we're no longer using periodic clocks, but only one-shot clocks only.
(which then leads to having to program them every time)

but arguably, that's because of HRTIMERS more than NOHZ
(e.g. I bet we still turn off periodic even for nohz as long as hrtimers are enabled)

