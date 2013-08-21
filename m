Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab3HUHeg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:34:36 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:41823 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab3HUHee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:34:34 -0400
Date: Wed, 21 Aug 2013 09:34:30 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, mm: Avoid step_size overflow and add comments
Message-ID: <20130821073430.GC27495@gmail.com>
References: <1377022270-20303-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377022270-20303-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> Current code

"Current code has two problems:"

> 1. shift step_size directly, and this could have overflow problem
>    after we shift step_size several times.

The most important piece of information is not explained: 
under what circumstances can this happen currently, what 
are the symptoms if this happens, roughly what kind of 
systems are affected, etc?

I mean the kind of information you'd put into a BIOS errata 
description or into any software changelog. You wouldn't 
primarily write about the mechanics of the change, but 
about the _actual impact_ of the change, to end users, 
right?

> 2. use MACRO to have shift to set to 5, but there is not
>    explanation about selection.
> 
> We can fix them with:
> 1. Add get_new_step_size(), and check overflow by comparing new_size
>    with old step_size.
> 2. add comment in it about why we are using 5.
> 
> That will make code more readable while not increasing size of
> init_mem_mapping().

Well, it gets not just more readable at a small size 
increase, but also the above unexplained overflow bug will 
be fixed as well, right?

Thanks,

	Ingo
