Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab3EMRRO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 13:17:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab3EMRRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 13:17:12 -0400
Date: Mon, 13 May 2013 19:13:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Colin Walters <walters@verbum.org>
Cc: Lucas De Marchi <lucas.de.marchi@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Denys Vlasenko <vda.linux@googlemail.com>
Subject: Re: [RFC] teach argv_split() to ignore the spaces surrounded by \e
Message-ID: <20130513171329.GA21906@redhat.com>
References: <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com> <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com> <20130510171054.GA27479@redhat.com> <CAKi4VAK7KA6WyVkuw+QMBnzF63b-67Gq-VmhWBs69Q0Wnc7wNw@mail.gmail.com> <20130513141633.GB1613@redhat.com> <20130513143537.GA3278@redhat.com> <1368461167.11935.39.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368461167.11935.39.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13, Colin Walters wrote:
>
> On Mon, 2013-05-13 at 16:35 +0200, Oleg Nesterov wrote:
>
> > Yes, we can change format_corename() to construct "argv" by hand, and
> > this was my iniital plan. But perhaps it would be better to not uglify
> > this code even more?
>
> Sure this \e is less code, but it seems pretty ugly to me.

Yes, I am not proud of this idea. But it is simple.

> Maybe a way
> to keep fs/coredump.c sane would be always constructing an argv, and
> then in the !ispipe case just join them into one string.

I don't think we should construct an argv if !ispipe, but this is minor.
The patch should be simple anyway. Just I do not want to touch this code ;)
and to complicate it more. and create another (2nd) case when when we need
to construct argv by hand.

> Though I'm still inclined to change systemd to read /proc/pid/cmdline
> like abrt does; that way it works on current kernels too.

Oh, I will be really happy to leave this this code alone and do nothing ;)

except format_corename() has another bug, it can leak ->corename but this
is another story (I'll send the patch).

Oleg.

