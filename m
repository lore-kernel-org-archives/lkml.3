Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751464AbaGHVid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:38:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbaGHVic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:38:32 -0400
Date: Tue, 8 Jul 2014 14:38:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-Id: <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
In-Reply-To: <20140708190849.GC17860@moon.sw.swsoft.com>
References: <20140703143318.568554771@openvz.org>
	<20140703151102.842945837@openvz.org>
	<20140708190849.GC17860@moon.sw.swsoft.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014 23:08:49 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Ping. Guys, any commens please?

Well, allowing a process to modify pretty deep internals like this is
always scary from a security point of view, and now we're removing
CAP_SYS_RESOURCE protections.  Yikes.  Convince me we aren't handing
out root here.

The changelog doesn't make it clear (to me) why this is actually being
done.  criu runs unprivileged?  What's the requirement here?

struct prctl_mm_map could do with a nice comment explaining its role in
the world.

I'm not seeing a coherent description of the proposed userspace
interface.  We'll eventually want to update the prctl manpage for this,
so how about laying out all the needed details now, at patch review
time so we can see what is proposed.

Why isn't the newly-added code under #ifdef CONFIG_CHECKPOINT_RESTORE?
