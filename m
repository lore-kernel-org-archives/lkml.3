Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388Ab3D2Hps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:45:48 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:47861 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3D2Hpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 03:45:47 -0400
MIME-Version: 1.0
In-Reply-To: <CAKgNAkiMOGtuCyvhSpku65p1ZJ5SfdYcOxxAU+H-mk-76wqOPw@mail.gmail.com>
References: <CAKgNAkh1TEkQiQ2g2jhbNzVTwpDYOreJt3rAukZCP9H1wh0mLQ@mail.gmail.com>
	<20130315153811.GD24305@sergelap>
	<CAKgNAkiMOGtuCyvhSpku65p1ZJ5SfdYcOxxAU+H-mk-76wqOPw@mail.gmail.com>
Date: Mon, 29 Apr 2013 09:45:45 +0200
Message-ID: <CAFLxGvzXkGcR=Wyx8YZKKRACEnNLMA0xQoDfruq7CT1D-FNLnA@mail.gmail.com>
Subject: Re: For review: user_namespaces(7) man page
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Michael Kerrisk-manpages <mtk.manpages@gmail.com>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vasily Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 21, 2013 at 4:52 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> Hi Serge,
>
> On Fri, Mar 15, 2013 at 4:38 PM, Serge Hallyn <serge.hallyn@ubuntu.com> wrote:
>> Hi,
>>
>> you mention that after creating a new user namespace you at first have
>> all capabilities in the new ns.  You don't explicitly mention (or I
>> missed it - I did see the mention of securebits) that if you want to
>> keep those capabilities after doing an exec, you need to first have
>> something mapped to uid 0 in the userns, and do setuid(0).
>
> Good point. I'll add something on that.
>
>> You might not want to list manpages from other projects,
>
> Actually, not a problem. Many of the pages in my set already do this.
>
>> but Eric's
>> shadow patches introduce some good new manpages as well.  Those aren't yet
>> accepted upstream, but if/when they are then mention at least of
>> subuid(5), subgid(5), and newuidmap(1) and newgidmap(1) might be good.
>
> I'll add those.
>
> Cheers,
>
> Michael

Can we please also document which capabilities are useless within an
user namespace?
E.g. CAP_MKNOD.
You get this capability but the kernel always checks it against the
initial userns.

Thanks,
//richard
