Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3JQKyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 06:54:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:39583 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219Ab3JQKyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 06:54:35 -0400
Message-ID: <525FC1DD.4030205@canonical.com>
Date: Thu, 17 Oct 2013 12:54:21 +0200
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
CC: mingo@kernel.org, imirkin@alum.mit.edu, linux-kernel@vger.kernel.org,
        daniel.vetter@ffwll.ch, robdclark@gmail.com
Subject: Re: [PATCH for 3.12] mutex: Avoid gcc version dependent __builtin_constant_p()
 usage.
References: <201310171945.AGB17114.FSQVtHOJFOOFML@I-love.SAKURA.ne.jp> <20131017105243.GM2675@laptop.programming.kicks-ass.net>
In-Reply-To: <20131017105243.GM2675@laptop.programming.kicks-ass.net>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

op 17-10-13 12:52, Peter Zijlstra schreef:
> On Thu, Oct 17, 2013 at 07:45:29PM +0900, Tetsuo Handa wrote:
>> Commit 040a0a37 "mutex: Add support for wound/wait style locks" used
>> "!__builtin_constant_p(p == NULL)" but gcc 3.x cannot handle such expression
>> correctly, leading to boot failure when built with CONFIG_DEBUG_MUTEXES=y.
> So I completely forgot all about this, but wouldn't something like:
>
>  !(__builtin_constant_p(p) && p == NULL)
>
> Not also work and generate the same code?
>
See earlier discussion. It was already answered why that was undesirable. ;)

~Maarten
