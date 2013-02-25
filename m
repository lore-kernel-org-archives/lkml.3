Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab3BYSJf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:09:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab3BYSJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:09:32 -0500
Date: Mon, 25 Feb 2013 19:08:02 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usermodehelper: Fix -ENOMEM return logic
Message-ID: <20130225180802.GA6160@redhat.com>
References: <1361802350-9299-1-git-send-email-lucas.demarchi@profusion.mobi> <20130225160642.GA31806@redhat.com> <CAMOw1v7S07YOLQaKBBSHkCqhf1JSB1ZabMeMUJagb4E8841opQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMOw1v7S07YOLQaKBBSHkCqhf1JSB1ZabMeMUJagb4E8841opQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Lucas De Marchi wrote:
>
> Yep. The current interface is confusing. I agree that a separate
> setup() + exec() would make more sense.

Great,

> > @@ -98,8 +98,14 @@ static int call_modprobe(char *module_na
> >         argv[3] = module_name;  /* check free_modprobe_argv() */
> >         argv[4] = NULL;
> >
> > -       return call_usermodehelper_fns(modprobe_path, argv, envp,
> > -               wait | UMH_KILLABLE, NULL, free_modprobe_argv, NULL);
> > +       info = call_usermodehelper_setup(...); // better name, please...
> > +       if (!info)
> > +               goto free_modname;
> > +
> > +       return call_usermodehelper_exec(info, wait);
>
> I'd say that in these cases the "call_" prefix has no meaning, and we
> could just use a "usermodehelper" as the namespace.

Oh, I agree with any naming.

So, I hope you will send v2. I'd suggest to split the fixes. 1/3
should create/export the new helpers, and 2-3 fix should call_modprobe()
and call_usermodehelper_keys(). But this is up to you, I won't insist.

Oleg.

