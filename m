Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185AbaDBTvx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:51:53 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41563 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933056AbaDBTvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:51:51 -0400
Message-ID: <533C6A51.6090305@linaro.org>
Date: Wed, 02 Apr 2014 12:51:45 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@sr71.net>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 0/5] Volatile Ranges (v12) & LSF-MM discussion fodder
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <20140401212102.GM4407@cmpxchg.org> <533B8C2D.9010108@linaro.org> <20140402183113.GL1500@redhat.com>
In-Reply-To: <20140402183113.GL1500@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 11:31 AM, Andrea Arcangeli wrote:
> On Tue, Apr 01, 2014 at 09:03:57PM -0700, John Stultz wrote:
>> Now... once you've chosen SIGBUS semantics, there will be folks who will
>> try to exploit the fact that we get SIGBUS on purged page access (at
>> least on the user-space side) and will try to access pages that are
>> volatile until they are purged and try to then handle the SIGBUS to fix
>> things up. Those folks exploiting that will have to be particularly
>> careful not to pass volatile data to the kernel, and if they do they'll
>> have to be smart enough to handle the EFAULT, etc. That's really all
>> their problem, because they're being clever. :)
> I'm actually working on feature that would solve the problem for the
> syscalls accessing missing volatile pages. So you'd never see a
> -EFAULT because all syscalls won't return even if they encounters a
> missing page in the volatile range dropped by the VM pressure.
>
> It's called userfaultfd. You call sys_userfaultfd(flags) and it
> connects the current mm to a pseudo filedescriptor. The filedescriptor
> works similarly to eventfd but with a different protocol.
So yea! I actually think (its been awhile now) I mentioned your work to
Taras (or maybe he mentioned it to me?), but it did seem like the
userfaltfd would be a better solution for the style of fault handling
they were thinking about. (Especially as actually handling SIGBUS and
doing something sane in a large threaded application seems very difficult).

That said, explaining volatile ranges as a concept has been difficult
enough without mixing in other new concepts :), so I'm hesitant to tie
the functionality together in until its clear the userfaultfd approach
is likely to land. But maybe I need to take a closer look at it.

thanks
-john
