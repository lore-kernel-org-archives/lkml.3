Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab3F3JCO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 05:02:14 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:38143 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3F3JCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 05:02:10 -0400
Date: Sun, 30 Jun 2013 17:02:03 +0800
From: =?utf-8?B?5byg5b+g5bGx?= <zzs0213@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] let kbuild mkdir for dir/file.o
Message-ID: <20130630090203.GA6557@greatfirst.com>
Mail-Followup-To: Michal Marek <mmarek@suse.cz>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	lkml <linux-kernel@vger.kernel.org>
References: <1370335532-17891-1-git-send-email-zzs0213@gmail.com>
 <1370335532-17891-2-git-send-email-zzs0213@gmail.com>
 <51CE11C2.5020406@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51CE11C2.5020406@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  # $(obj-dirs) is a list of directories that contain object files
> > -obj-dirs := $(dir $(multi-objs) $(subdir-obj-y))
> > +__subdir-obj-y := $(foreach o,$(obj-y),$(if $(filter-out $(o),$(notdir $(o))),$(o)))
>
> This complicated filter returns entries from $(obj-y) that contain a
> slash, is that correct? If so, is it really necessary? Why not simply
> add whole $(obj-y) to $(obj-dirs) and be done? $(multi-objs) is also
> added without any filtering.
>
> > +obj-dirs := $(dir $(multi-objs) $(__subdir-obj-y))

Yes, You are right.
It is enough that just add $(obj-y) to $(obj-dirs) directly.
I will resend the patch.

-- 
Best Regards,
zzs

