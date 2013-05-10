Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab3EJRox (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 13:44:53 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34302 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab3EJRow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 13:44:52 -0400
MIME-Version: 1.0
In-Reply-To: <20130510173511.GA28490@redhat.com>
References: <1368159316-31744-1-git-send-email-lucas.de.marchi@gmail.com>
 <1368159316-31744-3-git-send-email-lucas.de.marchi@gmail.com>
 <20130510125826.GA553@redhat.com> <CAKi4VALE8tFUTZ1qYwm0Eth1zFMU8xA6XC5RTnF1KCKYQp-0NQ@mail.gmail.com>
 <20130510153638.GA8179@redhat.com> <CAKi4VAJPXgiik9CGrVyk7cCvz-1913p1KL8tn5FvxH4w0r27bg@mail.gmail.com>
 <20130510171054.GA27479@redhat.com> <20130510173511.GA28490@redhat.com>
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Fri, 10 May 2013 14:44:31 -0300
Message-ID: <CAKi4VAK3paytaMGBmu0oVGcLUeuCbL7i3aht-Ho7rz7cdf5KTg@mail.gmail.com>
Subject: Re: [PATCH 3/3] init/Kconfig: Add option to set modprobe command
To: Oleg Nesterov <oleg@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 2:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 05/10, Oleg Nesterov wrote:
>>
>> On 05/10, Lucas De Marchi wrote:
>> >
>> > but I think it's a good tradeoff and covers other use cases as you
>> > pointed out as well.
>>
>> OK, good.
>
> Yes, perhaps this makes sense anyway but...
>
>> > Ok. I'll give it a try.
>>
>> Please wait a bit, I'll send v2. See below.
>
> Cough, wait ;)
>
> Why do we need theese changes ????
>
>> > > -char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
>> > > +char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe -q --";
>>
>> No. This is incompatible change, we shouldn't do this.
>
> Exactly. This can break a distro which writes to sys/kernel/modprobe.
>
> And if we do not do this, you can simply make a single trivial patch
> which does
>
>         -       char modprobe_path[KMOD_PATH_LEN] = "/sbin/modprobe";
>         +       char modprobe_path[KMOD_PATH_LEN] = CONFIG_DEFAULT_MODULE_LOAD_BIN;
>
> that it all. (or perhaps a kernel parameter makes more sense).
>
> Yes, this doesn't allow to pass the additional arguments, but is it
> that important?

Yes, because I don't want to simply change the binary to use, I want
to be able to use a general "kmod" binary that accept a command like
"load". Next version of kmod will accept things like this (see the
commit message in patch 3/3):

kmod load modulename

oh... and busybox users might be interested in this as well since they
can do "busybox modprobe modulename" directly, too


Lucas De Marchi
