Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab3FMClR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:41:17 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:58338 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756400Ab3FMClQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:41:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130613023831.GB10979@localhost>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
	<1371070996-20613-5-git-send-email-tj@kernel.org>
	<51B93038.9010202@huawei.com>
	<20130613023831.GB10979@localhost>
Date: Wed, 12 Jun 2013 19:41:15 -0700
X-Google-Sender-Auth: uxaGedoy6Rbg4V4ZlhwF3xZmsUI
Message-ID: <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jun 12, 2013 at 7:38 PM, Kent Overstreet <koverstreet@google.com> wrote:
> IMO, list_del() is preferred when the object shouldn't be reused (i.e.
> it gets taken off a list and then it's freed). list_del_init() could
> hide bugs.

Nah... use-after-frees are detected much more reliably by poisoning
anyway. Using list_del() instead of list_del_init() to hunt down
use-after-free isn't a good idea because you're likely to corrupt the
memory of unrelated area. I really don't see much point in using
list_del().

Thanks.

--
tejun
