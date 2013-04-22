Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab3DVRuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 13:50:23 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:35394 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3DVRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 13:50:21 -0400
MIME-Version: 1.0
In-Reply-To: <1366626208.2721.12.camel@laptop>
References: <5164DCE7.8080906@linux.vnet.ibm.com> <1366626208.2721.12.camel@laptop>
From: Paul Turner <pjt@google.com>
Date: Mon, 22 Apr 2013 10:49:50 -0700
Message-ID: <CAPM31RKaneDL_D-jXZegtRYxw0kf=PyiR_kdR9izM+-Q_QBC1g@mail.gmail.com>
Subject: Re: [PATCH] sched: wake-affine throttle
To: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Mike Galbraith <efault@gmx.de>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 3:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> OK,.. Ingo said that pipe-test was the original motivation for
> wake_affine() and since that's currently broken to pieces due to
> select_idle_sibling() is there still a benefit to having it at all?
>
> Can anybody find any significant regression when simply killing
> wake_affine()?
>

This matches our experience; we've always tuned toward a more
aggressive select_idle_sibling() for in-socket wake-ups.

We did recently turn it back on in the cross-socket case (e.g.
SD_NODE) however as we were able to observe a benefit on a few
workloads.
