Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab3CJMG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 08:06:28 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:52178 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3CJMG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 08:06:26 -0400
Message-ID: <513C773B.60802@gmail.com>
Date: Sun, 10 Mar 2013 16:06:19 +0400
From: Lijo Antony <lijo.kernel@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Simeon Bird <bladud@gmail.com>
CC: Linux Filesystem Development Mailinglist 
	<linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: Fwd: [Nepomuk] Better support for (desktop) file search / indexing
 applications
References: <201211011352.42476.Martin@lichtvoll.de> <6898338.Kmf2pUBmi1@deuteros> <201211101753.46211.Martin@lichtvoll.de> <10569573.iu1a6eiZCO@deuteros> <CAKRKD_W8pW+8kUO2HvgCQrtqnHOZzgeGiwAF5ER3Yad4OMcizg@mail.gmail.com> <CAKRKD_XvW3hjpboNJELMwDkFAsu80gvWXXtedgRmSpjZE6dSug@mail.gmail.com>
In-Reply-To: <CAKRKD_XvW3hjpboNJELMwDkFAsu80gvWXXtedgRmSpjZE6dSug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2013 08:51 AM, Simeon Bird wrote:
>
> Hi,
>
> We (nepomuk) recently looked at using fanotify, and indeed we would
> need user watches, support for moves and recursive directory watches
> (we need to support the case where /home is not a separate filesystem)
> before it would be useful to us. If you are interested in adding
> these, we would be delighted to use nepomuk as a test-case for them.
>
> We were wondering also if it would be possible to extend inotify a
> little? Our wishlist is:
>
> 1) Recursive folder watches
> 2) When a file moves, some way to get the destination without watching
> the directory it moved to, so moves can be tracked without watching
> every file on the system.

I am also interested in these features. As of now, my solutions are,

1) When the limit is reached, ask the user to increase the limit and 
restart the application.

2) When top level directory move is detected, do a file system search 
based on inode to find out the new location. Very slow and not fool proof.

I would also like to any other solutions for these problems. I am yet to 
look into fanotify.

-lijo

[leaving the rest for reference]

>
> I understand that there are reasons of security and performance why
> you cannot implement 1), but is 2) possible? Maybe by extending
> IN_MOVED_TO, or adding a new event type?
>
> 2) is actually in some ways the more severe problem for us. As well as
> being an indexer, nepomuk is a system that allows you to store file
> metadata such as ratings. When users move the files, they want the
> metadata to move too, so we need to track where the file moved, and
> thus at the moment we recursively watch everything. This is
> particularly problematic with removable media; because a lot of people
> will plug in an external drive and then move files onto it, we have to
> watch every drive as soon as it is plugged in. If we were able to get
> the destination of move events without watching the destination
> directory, we could watch only those directories with interesting
> metadata in, which would make things a lot easier.
>
> inotify move tracking would also be useful for other things - eg, a
> text editor could use inotify to see if a file it has open has moved
> and offer to re-open the file in its new location, which is impossible
> at the moment.
>
> Since the lack of recursive watches is really a problem because we
> have a tendency to run out of watches, it would also really help if
> the default limit was a bit higher -  most people seem to have > 8000
> folders, but I suspect far fewer have > 32000 (probably excepting
> those who are indexing kernel source trees: I have 21000, and half of
> that is KDE source).
>
> Would any of this be possible? If you happen to know of a better way
> to track moves using existing tools, that would be even better.
>
> Thanks,
> Simeon
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

