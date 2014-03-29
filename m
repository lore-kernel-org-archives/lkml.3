Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbaC2JwP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:52:15 -0400
Received: from mail-yk0-f176.google.com ([209.85.160.176]:51761 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbaC2JwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:52:13 -0400
MIME-Version: 1.0
X-Originating-IP: [84.208.52.246]
In-Reply-To: <20140328.214254.1620280677250220442.davem@davemloft.net>
References: <CAG-2HqVJPrTWXtuvDkU6MvfNj0MXfNuBMmdoKWtSd5kToZ3mMQ@mail.gmail.com>
 <20140328.172107.16072208664321602.davem@davemloft.net> <CAG-2HqVQ-MAZgsZAkykvVtbtYgDA3bfJA5rEqpdX5vBqPTjLJg@mail.gmail.com>
 <20140328.214254.1620280677250220442.davem@davemloft.net>
From: Tom Gundersen <teg@jklm.no>
Date: Sat, 29 Mar 2014 10:46:02 +0100
Message-ID: <CAG-2HqWQsLPaaHxMFn5Bha0BGKSAVZV9n87KTCsbQ1ewktzZvA@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] Provide netdev naming-policy via sysfs
To: David Miller <davem@davemloft.net>
Cc: David Herrmann <dh.herrmann@gmail.com>, netdev <netdev@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 29, 2014 at 2:42 AM, David Miller <davem@davemloft.net> wrote:
> From: Tom Gundersen <teg@jklm.no>
> Date: Fri, 28 Mar 2014 23:39:57 +0100
>
>> You mean coordinate with each other in userspace? If so, I still don't
>> see how this can ever be anything else than fragile. It will depend on
>> each userspace component actually opting in to whatever scheme we
>> devise, and does so correctly.
>
> Isn't that essentially what dbus is?
>
> A way for seperate userland components to coordinate their
> activities?

The protocol is not the problem. The issue is that this information
only exists reliably in the kernel, so we need to get it from there
somehow.

> I just simply don't like all of these ramdom keys getting
> added all over the place to guide udev behavior wrt. some
> other entity.

Well, in this case udev is sort of doing a bit of the kernel's work,
and it needs some information from the kernel to do it reliably.
Another approach would be for the kernel to just assign predictable
interface names to devices to begin with and we would never have to
touch them. You have all the information so that would be relatively
easy.

The issue I see with that is that there are several ways to generate
predictable names, and the user may want to chose between them, so
this is arguably policy that should not be in the kernel. If you don't
think that's a problem, I'd be happy to submit a patch to move all
this logic from udev to the kernel, just let me know how you see it.

Cheers,

Tom
