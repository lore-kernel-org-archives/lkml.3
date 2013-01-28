Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab3A1W5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 17:57:22 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:44986 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3A1W5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 17:57:20 -0500
Date: Mon, 28 Jan 2013 23:56:57 +0100
From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
To: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: ilw@linux.intel.com, johannes.berg@intel.com, wey-yi.w.guy@intel.com
Subject: iwlwifi/iwldvm soft lockup with 3.8.0-rc5 (was: almost unusable on
 3.8.0-rc5)
Message-ID: <20130128225657.GA17533@kashmir>
Mail-Followup-To: Mathieu Chouquet-Stringer <mathieu@csetco.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ilw@linux.intel.com, johannes.berg@intel.com,
	wey-yi.w.guy@intel.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Face: %JOeya=Dg!}[/#Go&*&cQ+)){p1c8}u\Fg2Q3&)kothIq|JnWoVzJtCFo~4X<uJ\9cHK'.w
 3:{EoxBR
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hello all,

Oh the irony, I was just starting an email saying wifi is almost
unusable for me with 3.8 and my machine (a thinkpad t530) completely
froze while typing it...

I was going to say I'm getting a lot of:
iwlwifi 0000:03:00.0: fail to flush all tx fifo queues

with this device:
03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 3e)
        Subsystem: Intel Corporation Centrino Ultimate-N 6300 3x3 AGN
        Kernel driver in use: iwlwifi

But now I will be able to give you links to the actual soft lockup:
http://mathieu.csetco.com/iwlwifi/iwlwifi-oops1.jpeg
http://mathieu.csetco.com/iwlwifi/iwlwifi-oops2.jpeg
http://mathieu.csetco.com/iwlwifi/iwlwifi-oops3.jpeg

The same machine works perfectly fine with a vanilla 3.7.  On 3.8,
before the machine froze I could see my download speed going up and down
like crazy (that's what prompted the "almost unusable" comment, it's so
painful loading a web page feels like being on dialup).

A rough text version is a follow:
BUG: soft lockup - CPU#1 stuck for 23s!
[...]
Call Trace:
iwl_trans_pcie_stop_device+0x15c/0x1c0 [iwlwifi]
iwl_down+0x1fd/0x300 [iwldvm]
iwlagn_prepare_restart+0x4f/0xd0 [iwldvm]
? idle_balance+0x110/0x2f0
iwl_bg_restart+0x52/0xe0 [iwldvm]
process_one_work+0x147/0x490
? iwl_op_mode_dvm_start+0xa50/0xa50 [iwldvm]
[...]

After that I the whole thing was frozen: keyboard/mouse would still work
but no IO would go whatsoever (even disk)...

The "fail to flush all tx fifo queues" are easy to reproduce: I get that
by copying file around / downloading and browsing the web.

Let me know if I can help in any way (like decoding addresses).

Cheers,
-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
