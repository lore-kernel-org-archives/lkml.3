Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577Ab3DCHun (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 03:50:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53974 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758017Ab3DCHuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 03:50:20 -0400
Date: Wed, 3 Apr 2013 08:50:17 +0100
From: Mel Gorman <mgorman@suse.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sourceware.org>
Subject: systemtap broken by removal of register_timer_hook
Message-ID: <20130403075017.GA2534@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ba6fdda4 (profiling: Remove unused timer hook) removed
[un]register_timer_hook due to a lack of upstream users and a belief
that there were no out-of-tree users. However, systemtap uses it and
with that patch applied, some stap scripts fail with

WARNING: "unregister_timer_hook" [/tmp/stapJoLMxD/stap_de6e19eaf7bd94629aba9d6f56cdfca5_8156.ko] undefined!
WARNING: "register_timer_hook" [/tmp/stapJoLMxD/stap_de6e19eaf7bd94629aba9d6f56cdfca5_8156.ko] undefined!
Error inserting module '/tmp/stapJoLMxD/stap_de6e19eaf7bd94629aba9d6f56cdfca5_8156.ko': Unknown symbol in module
WARNING: /usr/bin/staprun exited with status: 1
Pass 5: run failed.  Try again with another '--vp 00001' option.
Unexpected exit of STAP script at ./watch-dstate.pl line 305.

Can the patch be reverted or at least put a warning in place about it
being obsoleted until the systemtap folks come up with a replacement?

Systemtap folk, has his problem already been addressed?

-- 
Mel Gorman
SUSE Labs
