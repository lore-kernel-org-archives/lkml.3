Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759174AbaCTPNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:13:36 -0400
Received: from mail-ig0-f170.google.com ([209.85.213.170]:51549 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbaCTPNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:13:34 -0400
MIME-Version: 1.0
In-Reply-To: <20140320144127.1d411f26@alan.etchedpixels.co.uk>
References: <1395256011-2423-1-git-send-email-dh.herrmann@gmail.com>
	<CA+55aFyNORiS2XidhWoDBVyO6foZuPJTg_BOP3aLtvVhY1R6mw@mail.gmail.com>
	<CANq1E4TuiU6_J=N0WoPav=0AxOJ9G1w+FGvO15kmGP76i+-caw@mail.gmail.com>
	<20140320144127.1d411f26@alan.etchedpixels.co.uk>
Date: Thu, 20 Mar 2014 16:12:54 +0100
Message-ID: <CANq1E4Ro8bsgp1QS_Qf9KKBAMZH+joMW5DmfyZ4OBJuTxdXCZA@mail.gmail.com>
Subject: Re: [PATCH 0/6] File Sealing & memfd_create()
From: David Herrmann <dh.herrmann@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Karol Lewandowski <k.lewandowsk@samsung.com>,
        Kay Sievers <kay@vrfy.org>, Daniel Mack <zonque@gmail.com>,
        Lennart Poettering <lennart@poettering.net>,
        =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@bitplanet.net>,
        John Stultz <john.stultz@linaro.org>,
        Greg Kroah-Hartman <greg@kroah.com>, Tejun Heo <tj@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ryan Lortie <desrt@desrt.ca>,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, Mar 20, 2014 at 3:41 PM, One Thousand Gnomes
<gnomes@lxorguk.ukuu.org.uk> wrote:
> I think you want two things at minimum
>
> owner to seal
> root can always override

Why should root be allowed to override?

> I would query the name too. Right now your assumption is 'shmem only' but
> that might change with other future use cases or types (eg some driver
> file handles) so SHMEM_ in the fcntl might become misleading.

I'm fine with F_SET/GET_SEALS. But given you suggested requiring
MFD_ALLOW_SEALS for sealing, I don't see why we couldn't limit this
interface entirely to memfd_create().

> Whether you want some way to undo a seal without an exclusive reference as
> the file owner is another question.

No. You are never allowed to undo a seal but with an exclusive
reference. This interface was created for situations _without_ any
trust relationship. So if the owner is allowed to undo seals, the
interface doesn't make any sense. The only options I see is to not
allow un-sealing at all (which I'm fine with) or tracking users (which
is way too much overhead).

Thanks
David
