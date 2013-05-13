Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab3EMTU4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 15:20:56 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47821 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab3EMTUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 15:20:55 -0400
MIME-Version: 1.0
In-Reply-To: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1368472103-3427-1-git-send-email-cody@linux.vnet.ibm.com>
Date: Mon, 13 May 2013 22:20:53 +0300
X-Google-Sender-Auth: -amI7NfC-2nNs_YlkI8BhhOsDGE
Message-ID: <CAOJsxLF7xCiJmNn71zuNPGx1WzSj2BKeMVGXctfzvZODqVVU-A@mail.gmail.com>
Subject: Re: [PATCH RESEND v3 00/11] mm: fixup changers of per cpu pageset's
 ->high and ->batch
From: Pekka Enberg <penberg@kernel.org>
To: Cody P Schafer <cody@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Simon Jeons <simon.jeons@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Mel Gorman <mgorman@suse.de>, Linux MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Cody,

On Mon, May 13, 2013 at 10:08 PM, Cody P Schafer
<cody@linux.vnet.ibm.com> wrote:
> "Problems" with the current code:
>  1. there is a lack of synchronization in setting ->high and ->batch in
>     percpu_pagelist_fraction_sysctl_handler()
>  2. stop_machine() in zone_pcp_update() is unnecissary.
>  3. zone_pcp_update() does not consider the case where percpu_pagelist_fraction is non-zero

Maybe it's just me but I find the above problem description confusing.
How does the problem manifest itself? How did you find about it? Why
do we need to fix all three problems in the same patch set?

                        Pekka
