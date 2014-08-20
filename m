Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaHTUcC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 16:32:02 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:45735 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbaHTUcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 16:32:00 -0400
From: Catalin Iacob <iacobcatalin@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>
Subject: Re: nohz fail (was: perf related boot hang.)
Date: Wed, 20 Aug 2014 22:31:31 +0200
Message-Id: <1408566691-3023-1-git-send-email-iacobcatalin@gmail.com>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <20140811200931.GA18865@redhat.com>
References: <20140811200931.GA18865@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've also just hit what seems to be the same panic in 3.17-rc1 (ignore the 1
local patch, it's an unrelated change in a comment) twice in less than 1
hour. Hitting this twice in a short amount of time seems to be proof that the
3.17 merge window made it trigger more often. Both times I was running a grep
over a Firefox build tree which was taking a long time.

The stacktraces are slightly different but both have the "cancel timer from a
timer, followed by nmi" pattern. Pictures of the 2 stacktraces:
https://drive.google.com/file/d/0B_fRjDygGZSNY0RIc2dyYTExTjg/edit?usp=sharing
https://drive.google.com/file/d/0B_fRjDygGZSNS1pSWFkteURrOTQ/edit?usp=sharing
