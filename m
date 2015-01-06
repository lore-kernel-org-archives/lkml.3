Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104AbbAFQnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:43:40 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:58586 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbbAFQnj (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Tue, 6 Jan 2015 11:43:39 -0500
Message-ID: <1420562614.24290.5.camel@stgolabs.net>
Subject: Re: [PATCH] mutex: Always clear owner field upon mutex_unlock()
From: Davidlohr Bueso <dave@stgolabs.net>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>, Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Tue, 06 Jan 2015 08:43:34 -0800
In-Reply-To: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
References: <1420540175-30204-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-06 at 10:29 +0000, Chris Wilson wrote:
> Currently if DEBUG_MUTEXES is enabled, the mutex->owner field is only
> cleared iff debug_locks is active. This exposes a race to other users of
> the field where the mutex->owner may be still set to a stale value,
> potentially upsetting mutex_spin_on_owner() among others.
> 
> References: https://bugs.freedesktop.org/show_bug.cgi?id=87955
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>

Acked-by: Davidlohr Bueso <dave@stgolabs.net>

