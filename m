Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab3BGBRF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 20:17:05 -0500
Received: from ozlabs.org ([203.10.76.45]:58106 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757265Ab3BGBRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 20:17:00 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Jesse Gross <jesse@nicira.com>,
        LKML <linux-kernel@vger.kernel.org>, "Jon Masters" <jcm@redhat.com>,
        "Lucas De Marchi" <lucas.demarchi@profusion.mobi>
Subject: Re: No sysfs directory for openvswitch module when built-in
In-Reply-To: <1360087184.2857.2.camel@bwh-desktop.uk.solarflarecom.com>
References: <CAM_iQpVgEchb8UsxUP=w6OMbYx=zuP2yv=QwFhe8rPCbNBreVg@mail.gmail.com> <87boc0liug.fsf@rustcorp.com.au> <1360087184.2857.2.camel@bwh-desktop.uk.solarflarecom.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Feb 2013 10:08:09 +1030
Message-ID: <87lib1j9ni.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Hutchings <bhutchings@solarflare.com> writes:
> On Mon, 2013-02-04 at 16:29 +1030, Rusty Russell wrote:
>> Cong Wang <xiyou.wangcong@gmail.com> writes:
>> > Hello, Rusty, Jesse,
>> >
>> > I met an interesting problem when I compile openvswitch module as a
>> > built-in (actually I compile ALL kernel modules as built-in), there is
>> > no /sys/module/openvswitch/ directory created by the kernel in this
>> > case.
>> ...
>> > What's worse, the user-space init script thinks openvswitch module is
>> > not loaded by checking the exist of this directory, therefore refuses
>> > to start.
>> 
>> We only know built-in "modules" exist if we see a parameter or version
>> which mention them.  Looking for /sys/module/openvswitch/ is almost as
>> flawed as looking in /proc/modules.
>> 
>> I hacked up something which lists KBUILD_MODNAME for every element in my
>> kernel which did EXPORT_KERNEL or module_init, and most of them can
>> never be modules, though any could have parameters.  Even if we changed
>> the build system so we could tell things which "could have been a
>> module", it's silly.
> [...]
>
> Isn't this information already provided by modules.builtin?

(CC's trimmed)

Thanks Ben, I learned something!  I hadn't spotted that tristate vars
get set to Y instead of y.  Subtle...

So we already have the infrastructure, and copy it into the module dir
(though logically it's a kernel property and belongs in /proc).
eg. lsmod doesn't list them, which is a bit weird, though modprobe
"succeeds".

A quick grep through my /etc shows 5 scripts using lsmod and 1 using
/sys/module to check for presence of modules.  Should the kernel pad
/proc/modules with entries for builtins?

Thoughts welcome...
Rusty.
