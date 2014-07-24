Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbaGXTV5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:21:57 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:50604 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934246AbaGXTVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:21:55 -0400
Date: Thu, 24 Jul 2014 23:21:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk-manpages <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>
Subject: Re: [rfc 1/4] mm: Introduce may_adjust_brk helper
Message-ID: <20140724192152.GC17876@moon>
References: <20140724164657.452106845@openvz.org>
 <20140724165047.437075575@openvz.org>
 <CAGXu5j+QHcrYjT8F9TZLA8YbJzZed28scp2y22QNO20sRF8Ndw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+QHcrYjT8F9TZLA8YbJzZed28scp2y22QNO20sRF8Ndw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 12:18:56PM -0700, Kees Cook wrote:
> >
> > +static inline int may_adjust_brk(unsigned long rlim,
> > +                                unsigned long new_brk,
> > +                                unsigned long start_brk,
> > +                                unsigned long end_data,
> > +                                unsigned long start_data)
> > +{
> > +       if (rlim < RLIMIT_DATA) {
> 
> Won't rlim always be the value from a call to rlimit(RLIMIT_DATA)? Is
> there a good reason to not just put the rlimit() call in
> may_adjust_brk()? This would actually be an optimization in the
> prctl_set_mm case, since now it calls rlimit() unconditionally, but
> doesn't need to.

Nope, we use it for rlimit(RLIMIT_STACK) when checking for
@start_stack member.
