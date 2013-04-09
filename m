Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935184Ab3DIS1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:27:12 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:50828 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934841Ab3DIS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:27:08 -0400
MIME-Version: 1.0
In-Reply-To: <51644E22.1050305@ti.com>
References: <1365465287-24530-1-git-send-email-abrestic@chromium.org>
	<51642BD5.4030803@ti.com>
	<CAL1qeaGW=m+DNbGhEzTJBDt1NNpPrVcBzzWzhk447hf2tyb2fw@mail.gmail.com>
	<51644E22.1050305@ti.com>
Date: Tue, 9 Apr 2013 11:27:07 -0700
Message-ID: <CAL1qeaEbakXL1wpURSGDJ=_FojoJ7DO4CJtj+pwPh32fufwjDQ@mail.gmail.com>
Subject: Re: [PATCH] thermal: fix frequency table lookup bugs
From: Andrew Bresticker <abrestic@google.com>
To: Eduardo Valentin <eduardo.valentin@ti.com>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You do two things in this change on cpu_cooling.c: (1) fix the case where
> the loop is kept running indefinitely. (2) Reserve a specific role for each
> index in this function.

So the issue is that the changes are not independent.  With just the
fix for the infinite loop, get_cpu_frequency() is still completely
broken because it is not interpreting the level correctly and will
return the wrong frequency (and thus not throttling correctly, which
is bad).  Perhaps the commit should be more general, like "fix
handling of invalid frequency table entries"?  What do you think?

Thanks,
Andrew
