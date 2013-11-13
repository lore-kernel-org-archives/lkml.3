Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758724Ab3KMIHO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 03:07:14 -0500
Received: from dmz-mailsec-scanner-3.mit.edu ([18.9.25.14]:54797 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757480Ab3KMIHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 03:07:11 -0500
X-AuditID: 1209190e-b7efb6d000000bb9-d2-5283332d3ffd
Date: Wed, 13 Nov 2013 03:07:06 -0500
From: Greg Price <price@MIT.EDU>
To: "Theodore Ts'o" <tytso@MIT.EDU>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 0/9] random: code cleanups
Message-ID: <cover.1384329436.git.price@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGIsWRmVeSWpSXmKPExsUixG6noqtn3Bxk8LFP0GLaRnGL3XMWs1hc
	3jWHzYHZ48yCI+wenzfJeZxo+cIawBzFZZOSmpNZllqkb5fAldHxfhdLwWaOinv/9jI3MD5h
	62Lk5JAQMJHYc24yC4QtJnHh3nqgOBeHkMBsJolrs0+yQDgbGSUm3X7ODFIlJPCLUeLGmmwQ
	m0VAVWLZyvtgcTYBBYkf89eB2SICyhKrZm5iArGZBbIktt+dxQpiCwvoSpyY+pURxOYVMJB4
	dfwKM4QtKHFy5hMWiHotiRv/XgL1cgDZ0hLL/3GAhEUFVCSmnNzGNoGRfxaSjllIOmYhdCxg
	ZF7FKJuSW6Wbm5iZU5yarFucnJiXl1qka6yXm1mil5pSuokRFJycknw7GL8eVDrEKMDBqMTD
	axHTFCTEmlhWXJl7iFGSg0lJlNdJpzlIiC8pP6UyI7E4I76oNCe1+BCjBAezkgjvAWGgHG9K
	YmVValE+TEqag0VJnPcmh32QkEB6YklqdmpqQWoRTFaGg0NJgvevIVCjYFFqempFWmZOCUKa
	iYMTZDgP0PCZIDW8xQWJucWZ6RD5U4yKUuK8uSAJAZBERmkeXC8sebxiFAd6RZh3NkgVDzDx
	wHW/AhrMBDTYorgJZHBJIkJKqoHRQ0QxNsBJbes28b3a4SFsnj+/O7fMOLhc5cTDjLVnTrQc
	Kngn6PRgt9qvP49VjgoapmZe5FKRDpf50hJ1b1r1T/ssd6aoJx/zppt/ick/uWnfIVW9LYEz
	Gpck8XimL25k79w8W9aq4pT9/PRnWQfravpl0jXtZp7R1U9S2yfrdCRk4fdQif9KLMUZiYZa
	zEXFiQC4meL2+QIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series has my cleanups rebased onto the random.git tree, at
v3.11-20-g392a546.

Four of the patches touch comments only.  Three simplify code without
changing its behavior (total diffstat: 32 insertions, 64 deletions).
One drops a use of the lock where it doesn't now protect anything,
and one tightens slightly a bound on a sysctl value to avoid a
pathological case.

The bugfix that was in v1 was taken care of by Peter in a283b5c45
("random: allow fractional bits to be tracked").

Cheers,
Greg


Greg Price (9):
  random: fix typos / spelling errors in comments
  random: fix comment on proc_do_uuid
  random: fix description of get_random_bytes
  random: simplify loop in random_read
  random: fix comment on "account"
  random: simplify accounting logic
  random: forget lock in lockless accounting
  random: tighten bound on random_read_wakeup_thresh
  random: simplify accounting code

 drivers/char/random.c | 144 +++++++++++++++++++++-----------------------------
 1 file changed, 60 insertions(+), 84 deletions(-)

-- 
1.8.3.2
