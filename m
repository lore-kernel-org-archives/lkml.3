Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab3EUR1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:27:51 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:60016 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3EUR1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:27:49 -0400
Message-ID: <1369157265.2615.28.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH v4 net-next 1/4] net: implement support for low latency
 socket polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Dave Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Or Gerlitz <or.gerlitz@gmail.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 18:27:45 +0100
In-Reply-To: <20130521142650.18498.71715.stgit@ladj378.jer.intel.com>
References: <20130521142641.18498.52856.stgit@ladj378.jer.intel.com>
	 <20130521142650.18498.71715.stgit@ladj378.jer.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19882.005
X-TM-AS-Result: No--12.495900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 17:26 +0300, Eliezer Tamir wrote:
> Adds a new ndo_ll_poll method and the code that supports and uses it.
> This method can be used by low latency applications to busy poll ethernet
> device queues directly from the socket code. The ip_low_latency_poll sysctl
> entry controls how many cycles to poll. Set to zero to disable.
[...]

One more general point: why is this treated as an IPv4 option (in
Kconfig and sysctls)?  I don't have any particular expectation that it
will be used with network protocols other than IPv4 and v6 any time
soon, but logically it's not dependent on them.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

