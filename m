Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759830Ab3BZJCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:02:49 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52868 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab3BZJCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:02:46 -0500
X-AuditID: 9c93016f-b7b46ae000007f43-95-512c7a339678
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: acme@infradead.org, <linux-kernel@vger.kernel.org>, feng.tang@intel.com,
        namhyung.kim@lge.com
Subject: Re: [PATCH 1/2] perf annotate: Fix build with NO_NEWT=1
References: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
Date: Tue, 26 Feb 2013 18:02:43 +0900
In-Reply-To: <1361854923-1814-1-git-send-email-michael@ellerman.id.au>
	(Michael Ellerman's message of "Tue, 26 Feb 2013 16:02:02 +1100")
Message-ID: <87y5ebsb0s.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, 26 Feb 2013 16:02:02 +1100, Michael Ellerman wrote:
> Commit 18c9e5c "Make it to be able to skip unannotatable symbols" broke
> the build with NO_NEWT=1:
>
>    CC builtin-annotate.o
> builtin-annotate.c: In function 'hists__find_annotations':
> builtin-annotate.c:161:4: error: duplicate case value
> builtin-annotate.c:154:4: error: previously used here
> make: *** [builtin-annotate.o] Error 1
>
> This is because without NEWT support K_LEFT is #defined to -1 in
> utils/hist.h
>
> Fix it by shifting the K_LEFT/K_RIGHT #defines out of the likely range
> of error values.

Argh, didn't check NO_NEWT build on this, sorry.

The hist_entry__tui_annotate() - hence, symbol__tui_annotate() - returns
either key code or error code.  This is not good IMHO but not sure it's
worth refactoring.  Maybe we can move the error check to under default
case so that possible future error checks to be done?

Thanks,
Namhyung
