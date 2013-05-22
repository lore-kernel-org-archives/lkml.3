Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab3EVQAy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 12:00:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753956Ab3EVQAx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 12:00:53 -0400
Date: Wed, 22 May 2013 17:57:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usermodehelper: kill the sub_info->path[0] check
Message-ID: <20130522155710.GA16571@redhat.com>
References: <20130520165559.GA19645@redhat.com> <CAKi4VAJfYJ1SJzBj7QwOOu9ZoKqvQUWefGyN8jKzDCTQ7AaqyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAJfYJ1SJzBj7QwOOu9ZoKqvQUWefGyN8jKzDCTQ7AaqyA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lucas,

On 05/21, Lucas De Marchi wrote:
>
> Acked-By: Lucas De Marchi <lucas.demarchi@intel.com>

Thanks.

> > @@ -147,6 +147,9 @@ int __request_module(bool wait, const char *fmt, ...)
> >          */
> >         WARN_ON_ONCE(wait && current_is_async());
> >
> > +       if (!modprobe_path[0])
> > +               return 0;
> > +
>
> Any reason to not return -EINVAL here except for maintaining the
> previous behavior?

But for what?

Keep the previous behaviour is important. And this matches, say,
kobject_uevent_env().

> Checking the callers reveals just a few of them
> actually check the return value and IMO this is no different than the
> binary not existing and failing later on exec.

Yes, agreed. And perhaps request_module() is different. For example,
search_binary_handler(). Perhaps we should change this, but imho this
needs more patches/discussion.

This is like the previous commit 264b83c0 reverted by this patch, the
change tries to be simple and conservative.

Oleg.

