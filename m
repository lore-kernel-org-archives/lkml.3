Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759669AbaGXSuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:50:18 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:51961 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759063AbaGXSuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:50:16 -0400
Date: Thu, 24 Jul 2014 22:50:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Vagin <avagin@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>
Subject: Re: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
Message-ID: <20140724185013.GB17876@moon>
References: <20140708190849.GC17860@moon.sw.swsoft.com>
 <20140708143830.ea078ef01e1d7d31276edbcd@linux-foundation.org>
 <20140708221336.GL17860@moon.sw.swsoft.com>
 <20140709141318.GM17860@moon.sw.swsoft.com>
 <CAGXu5jKmTSb0YmNFDtr-jymrhy_s_PXUuvj3WKYffSU98gwyqg@mail.gmail.com>
 <20140709150604.GN17860@moon.sw.swsoft.com>
 <20140711173625.GD19702@moon>
 <CAGXu5jL3exT4j+8rjMv1O54uJWQ5UHL69Z-24b61rhXROqZamQ@mail.gmail.com>
 <20140724134828.GA3553@paralelels.com>
 <CAGXu5j+=i7hgyMjRRvvk8uuT_eyoD9wGNhcdZZQgQiwDoSoMXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+=i7hgyMjRRvvk8uuT_eyoD9wGNhcdZZQgQiwDoSoMXA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 11:44:50AM -0700, Kees Cook wrote:
...
> >
> > The file can have a suid bit, so after executing it we may lose ability
> > to attach to it. To check that we can check that uid and gid is zero
> > in a current userns (local root).
> >
> > What else do we need to check?
> 
> Yeah, I think all the checks are sufficient, but I (and Julien) are
> still trying to think about side-effects.
> 
> It would be nice if these checks (like the rlimit checks) were merged
> into some common helper. That way if something changes in the exec
> path, it won't go missed in the c/r path.

For rlimit I've done a separate helper in new rfc series, please take a look.
