Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689Ab3EMOT7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:19:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751071Ab3EMOT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:19:58 -0400
Date: Mon, 13 May 2013 16:16:33 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Lucas De Marchi <lucas.de.marchi@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
Message-ID: <20130513141633.GB1613@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com> <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com> <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com> <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com> <20130510171054.GA27479@redhat.com> <CAKi4VAK7KA6WyVkuw+QMBnzF63b-67Gq-VmhWBs69Q0Wnc7wNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKi4VAK7KA6WyVkuw+QMBnzF63b-67Gq-VmhWBs69Q0Wnc7wNw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Lucas De Marchi wrote:
>
> On Fri, May 10, 2013 at 2:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> >> > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
> >> > +char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
> >
> > No. This is incompatible change, we shouldn't do this.
>
> But then what option do we have? I don't think any distro writing to
> sysctl would stop working without "-q --".

Who knows?

Again, I won't argue, I simply do not know. But this is incompatible
change.

> And if they are indeed
> using this during boot, I think they would be much safer to just
> change to set this at compile time like this patch is trying to do.

Personally I think that "compile time" is not the best choice, but
I won't argue.

> Otherwise, the options are really ugly:
>
> 1) always give "-q --" by putting this on the kasprintf() call:
> kasprintf(GFP_KERNEL, "%s -q -- %s", modprobe_command, module_name).
> 2) provide a proc_dostring_modprobe, which ensures "-q --" is appended
> to the provided path

Agreed, both options do not look nice.

Lucas. I will be happy to resend the argv_split/call_modprobe changes,
but I can't judge whether we can/want do this.

Oleg.

