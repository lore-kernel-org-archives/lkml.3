Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3EPRRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 13:17:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752734Ab3EPRRb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 13:17:31 -0400
Date: Thu, 16 May 2013 19:13:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Colin Walters <walters@verbum.org>,
        Denys Vlasenko <vda.linux@googlemail.com>, Jiri Slaby <jslaby@suse.cz>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Neil Horman <nhorman@tuxdriver.com>, security@kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] usermodehelper: check subprocess_info->path != NULL
Message-ID: <20130516171337.GA24031@redhat.com>
References: <20130515201158.GA14606@redhat.com> <20130516154323.GA19060@redhat.com> <20130516154355.GB19060@redhat.com> <CAKi4VAKj+s0Z9QHfqwG3+y33puL4dVaou5ys+eiD-yLf8h5QrA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAKj+s0Z9QHfqwG3+y33puL4dVaou5ys+eiD-yLf8h5QrA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Lucas De Marchi wrote:
>
> >
> >         - kill or justify ->path[0] check
>
> I'm not sure about this, it's already there before my refactor and I
> don't think it makes any good. From modprobe pespective, I'd say it
> would be better to give an error than say everything went ok.

Agreed. And, I forgot to mention, if we kill this check then we do
not need this patch (although I need to recheck), execve will fail
and nothing bad should happen.

Just I think it would be better to start with the trivial fix, then
decide what should we actually do.

> Acked-By: Lucas De Marchi <lucas.demarchi@intel.com>

Thanks,

Oleg.

