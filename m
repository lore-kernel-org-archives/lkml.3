Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab3FXWui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 18:50:38 -0400
Received: from dmz-mailsec-scanner-8.mit.edu ([18.7.68.37]:45001 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750858Ab3FXWuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 18:50:37 -0400
X-AuditID: 12074425-b7f0c8e000000953-3b-51c8cd3c1659
Date: Mon, 24 Jun 2013 18:50:30 -0400
From: Greg Price <price@MIT.EDU>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH] perf report: Add option to collapse undesired parts of
 call graph
Message-ID: <20130624225029.GX22203@biohazard-cafe.mit.edu>
References: <20121207072726.GY22203@biohazard-cafe.mit.edu>
 <20130111052736.GG3054@ghostprotocols.net>
 <20130623031720.GW22203@biohazard-cafe.mit.edu>
 <20130623215327.GA995@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130623215327.GA995@krava.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEKsWRmVeSWpSXmKPExsUixCmqrWtz9kSgwcwlnBYX2y6yWRx4fIDF
	YuveNywWR8/+ZbK4vGsOm8WlAwuYLNYcWczuwO5x5SmHx+kePY+ds+6ye7zfd5XNY+6uPkaP
	z5vkAtiiuGxSUnMyy1KL9O0SuDImNN1hLrjHWXH5y0qWBsZj7F2MnBwSAiYSF68cZ4WwxSQu
	3FvP1sXIxSEksI9Roun+OkYIZyOjxIrpnUwQzmdGiY6rX5lBWlgEVCX2X53KBmKzCShI/Ji/
	DiwuAmQ/beoHs5kF/jBK/O/PArGFBSIkpm/+D7aOV8BaYuWcDmaIoUcYJTr3zIBKCEqcnPmE
	BaJZS+LGv5dAmzmAbGmJ5f84QMKcQGf/+/mbCcQWFVCRuLa/nW0Co+AsJN2zkHTPQuhewMi8
	ilE2JbdKNzcxM6c4NVm3ODkxLy+1SNdCLzezRC81pXQTIygq2F1UdzBOOKR0iFGAg1GJh3dm
	zIlAIdbEsuLK3EOMkhxMSqK8C04DhfiS8lMqMxKLM+KLSnNSiw8xSnAwK4nwhooA5XhTEiur
	UovyYVLSHCxK4rxit3YGCgmkJ5akZqemFqQWwWRlODiUJHhVzwA1ChalpqdWpGXmlCCkmTg4
	QYbzAA03AanhLS5IzC3OTIfIn2JUlBLnNQVJCIAkMkrz4HphSesVozjQK8K8giBVPMCEB9f9
	CmgwE9DgyanHQQaXJCKkpBoYmTTFft8qXym8tbGu8onxY1chuWke8bJX58buL9TYJn5ywl2+
	kAuBpeqa00LDdjnYxM5gyf3XvGNK0NW0uowLNqL8xjdtDD4KP7vmebbqGLP/m89PFOJ33X6/
	6AY/T7O51pLjCYVmNf4r2Se2TXSr+uIWomN4bEfuCpaOJSnKIVuqjWXFFOWUWIozEg21mIuK
	EwHEPj1ZNQMAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 11:53:27PM +0200, Jiri Olsa wrote:
> Seems useful, sort of oposite to parent option (-p)

Cool, good to hear.


> Any reason why not add this for top?

Only because I didn't think about it. :)  Seems like a good idea; I'll
add that.


> > diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> > index b2ecad6..a14489c 100644
> > --- a/tools/perf/util/machine.c
> > +++ b/tools/perf/util/machine.c
> > @@ -11,6 +11,10 @@
> >  #include <stdbool.h>
> >  #include "unwind.h"
> >  
> > +regex_t blackbox_regex;
> > +const char *blackbox_pattern;
> > +int have_blackbox = 0;
> 
> util/sort.c mich be better place for this

Sure, happy to put it there.


> It could also make sense to allow sorting on this
> the same way as we do for '-s parent' and report only
> '[other]' and 'blackbox' entries.

Could be.  My inclination would be to wait for someone to show up
wanting to use that functionality, because it's not yet obvious to me
why it will be useful.


> Also I dont like the 'blackbox' option name, it should
> complement the parent option somehow.. but no idea ;-)

OK, I'll think of some alternative possible names.


Thanks for the review!

Cheers,
Greg
