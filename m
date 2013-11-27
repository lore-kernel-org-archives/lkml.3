Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab3K0FY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:24:29 -0500
Received: from edison.jonmasters.org ([173.255.233.168]:41799 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3K0FYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:24:02 -0500
X-Greylist: delayed 1670 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Nov 2013 00:24:02 EST
Message-ID: <52957B5E.60701@jonmasters.org>
Date: Tue, 26 Nov 2013 23:55:58 -0500
From: Jon Masters <jonathan@jonmasters.org>
Organization: World Organi{s,z}ation of Broken Dreams
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: tony.luck@intel.com, peterz@infradead.org, linux-kernel@vger.kernel.org
References: <20131111171307.GA27002@linux.vnet.ibm.com>
In-Reply-To: <20131111171307.GA27002@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: Re: Does Itanium permit speculative stores?
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 12:13 PM, Paul E. McKenney wrote:
> Hello, Tony,
> 
> Does Itanium permit speculative stores?  For example, on Itanium what are
> the permitted outcomes of the following litmus test, where both x and y
> are initially zero?
> 
> 	CPU 0				CPU 1
> 
> 	r1 = ACCESS_ONCE(x);		r2 = ACCESS_ONCE(y);
> 	if (r1)				if (r2)
> 		ACCESS_ONCE(y) = 1;		ACCESS_ONCE(x) = 1;
> 
> In particular, is the outcome (r1 == 1 && r2 == 1) possible on Itanium
> given this litmus test?
> 
> 							Thanx, Paul
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

Btw, I was reading through some UEFI docs and noticed a reference to "A
Formal Specification of Intel Itanium Processor Family Memory Ordering",
then remembered this thread. In case it's of use:

http://www.intel.com/design/itanium/downloads/251429.htm

Jon.

