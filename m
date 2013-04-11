Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935551Ab3DKVQm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 17:16:42 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:51109 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934821Ab3DKVQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 17:16:01 -0400
Message-ID: <1365714957.7355.39.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [ 026/171 ] sfc: Only use TX push if a single descriptor is to
 be written
From: Ben Hutchings <bhutchings@solarflare.com>
To: Steven Rostedt <rostedt@goodmis.org>
CC: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Date: Thu, 11 Apr 2013 22:15:57 +0100
In-Reply-To: <20130411202550.471143447@goodmis.org>
References: <20130411202503.783159048@goodmis.org>
	 <20130411202550.471143447@goodmis.org>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19790.000
X-TM-AS-Result: No--20.506500-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aside from #21-26 in this series, and the deadlock fix required on top
of #24, there are several more fixes for sfc that I think are suitable
for 3.6.11.y.

These commits were cherry-picked for 3.4.38 and can also be
cherry-picked cleanly on top of 3.6.11.1 plus the 7 patches you already
have:

d5e8cc6c946e sfc: Really disable flow control while flushing
bfeed902946a sfc: Convert firmware subtypes to native byte order in efx_mcdi_get_board_cfg()
9724a8504c87 sfc: Add parentheses around use of bitfield macro arguments
0a6e5008a9df sfc: Fix MCDI structure field lookup
450783747f42 sfc: Avoid generating over-length MC_CMD_FLUSH_RX_QUEUES request
525d9e824018 sfc: Work-around flush timeout when flushes have completed
ef492f11efed sfc: Correctly initialise reset_method in siena_test_chip()
ebf98e797b4e sfc: Fix timekeeping in efx_mcdi_poll()

Please let me know whether you're prepared to include these in the
current update.  I can then run some automated tests with your selected
set of patches applied.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

