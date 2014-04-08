Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbaDHT4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 15:56:55 -0400
Received: from smtp.01.com ([199.36.142.181]:37288 "EHLO smtp.01.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757633AbaDHT4x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 15:56:53 -0400
Message-ID: <53445481.3030202@agliodbs.com>
Date: Tue, 08 Apr 2014 15:56:49 -0400
From: Josh Berkus <josh@agliodbs.com>
Organization: PostgreSQL Experts Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Robert Haas <robertmhaas@gmail.com>, Christoph Lameter <cl@linux.com>
CC: Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andres Freund <andres@2ndquadrant.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, sivanich@sgi.com
Subject: Re: [PATCH 0/2] Disable zone_reclaim_mode by default
References: <1396910068-11637-1-git-send-email-mgorman@suse.de>	<5343A494.9070707@suse.cz>	<alpine.DEB.2.10.1404080914280.8782@nuc> <CA+TgmoY=vUdtdnJUEK1h-UcaNoqqLUctt44S8vj2B7EVUXUOyA@mail.gmail.com> <WM!55d2a092da9f6180473043487a4eb612ae8195f78d2ffdd83f673ed5cb2cb9659cf61e0c8d5bae23f5c914057bcd2ee4!@asav-3.01.com>
In-Reply-To: <WM!55d2a092da9f6180473043487a4eb612ae8195f78d2ffdd83f673ed5cb2cb9659cf61e0c8d5bae23f5c914057bcd2ee4!@asav-3.01.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2014 03:53 PM, Robert Haas wrote:
> In an ideal world, the kernel would put the hottest pages on the local
> node and the less-hot pages on remote nodes, moving pages around as
> the workload shifts.  In practice, that's probably pretty hard.
> Fortunately, it's not nearly as important as making sure we don't
> unnecessarily hit the disk, which is infinitely slower than any memory
> bank.

Even if the kernel could do this, we would *still* have to disable it
for PostgreSQL, since our double-buffering makes our pages look "cold"
to the kernel ... as discussed.

-- 
Josh Berkus
PostgreSQL Experts Inc.
http://pgexperts.com
