Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbaIBPzd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 11:55:33 -0400
Received: from mail-oi0-f43.google.com ([209.85.218.43]:58681 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaIBPzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 11:55:32 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz>
References: <alpine.LNX.2.00.1409021101450.2481@pobox.suse.cz>
Date: Tue, 2 Sep 2014 11:55:31 -0400
X-Google-Sender-Auth: nZICOPLbcSBuejwDUl-9nXnL1Ww
Message-ID: <CA+5PVA7oZVWAiVTyiRkW5H1jB7JTPLZv==upSm6FcPZyj8hV5A@mail.gmail.com>
Subject: Re: [PATCH] Revert "leds: convert blink timer to workqueue"
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Vincent Donnefort <vdonnefort@gmail.com>, Bryan Wu <cooloney@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 5:03 AM, Jiri Kosina <jkosina@suse.cz> wrote:
> This reverts commit 8b37e1bef5a6b60e949e28a4db3006e4b00bd758.
>
> It's broken as it changes led_blink_set() in a way that it can now sleep
> (while synchronously waiting for workqueue to be cancelled). That's a
> problem, because it's possible that this function gets called from atomic
> context (tpt_trig_timer() takes a readlock and thus disables preemption).
>
> This has been brought up 3 weeks ago already [1] but no proper fix has
> materialized, and I keep seeing the problem since 3.18-rc1.
>
> [1] https://lkml.org/lkml/2014/8/16/128

FWIW we're seeing it reported in Fedora too.  Perhaps a revert is the
right approach for now.

josh
