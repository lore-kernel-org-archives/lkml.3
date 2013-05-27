Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200Ab3E0IaF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:30:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37075 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3E0IaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:30:03 -0400
Date: Mon, 27 May 2013 10:29:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        rob clark <robclark@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH v3 2/3] mutex: add support for wound/wait style locks, v3
Message-ID: <20130527082948.GF2781@laptop>
References: <20130428165914.17075.57751.stgit@patser>
 <20130428170407.17075.80082.stgit@patser>
 <20130430191422.GA5763@phenom.ffwll.local>
 <519CA976.9000109@canonical.com>
 <20130522161831.GQ18810@twins.programming.kicks-ass.net>
 <CAKMK7uHYPdUgbuXAHCZi7xMQUUF8EU5z3F09ZkvGmm33iYtjPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uHYPdUgbuXAHCZi7xMQUUF8EU5z3F09ZkvGmm33iYtjPA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 22, 2013 at 06:49:04PM +0200, Daniel Vetter wrote:
> - _slow functions can check whether all acquire locks have been
> released and whether the caller is indeed blocking on the contending
> lock. Not doing so could either result in needless spinning instead of
> blocking (when blocking on the wrong lock) or in deadlocks (when not
> dropping all acquired).

We could add ww_mutex_assert_context_empty() or somesuch so that
paranoid people have a means of expressing themselves :-)
