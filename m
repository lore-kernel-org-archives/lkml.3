Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966946Ab3HIALx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:11:53 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:57198 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966882Ab3HIALv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
References: <cover.1375729665.git.luto@amacapital.net> <20130807134058.GC12843@quack.suse.cz>
 <520286A4.1020101@intel.com> <CALCETrXAz1fc7y07LhmxNh6zA_KZB4yv57NY2MrhUwKdkypB9w@mail.gmail.com>
 <20130808101807.GB4325@quack.suse.cz> <CALCETrX1GXr58ujqAVT5_DtOx+8GEiyb9svK-SGH9d+7SXiNqQ@mail.gmail.com>
 <20130808185340.GA13926@quack.suse.cz> <CALCETrVXTXzXAmUsmmWxwr6vK+Vux7_pUzWPYyHjxEbn3ObABg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 8 Aug 2013 17:11:30 -0700
Message-ID: <CALCETrVZBpZDQ7-QjDYYQyGGtCEAk-ydb0DUUA9gcFtj4JYv6w@mail.gmail.com>
Subject: Re: [RFC 0/3] Add madvise(..., MADV_WILLWRITE)
To: Jan Kara <jack@suse.cz>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 8, 2013 at 12:25 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Whoops -- I read your email too quickly.  I haven't tried
> MADV_WILLNEED, but I think I tried reading each page to fault them in.
>  Is there any reason to expect MADV_WILLNEED to do any better?  I'll
> try to do some new tests to see how well this all works.
>
> (I imagine that freshly fallocated files are somehow different when
> read, since there aren't zeros on the disk backing them until they get
> written.)

Well, this will teach me to write code based on an old benchmark from
memory.  It seems that prefaulting for read is okay on Linux 3.9 --
latencytop isn't do_wp_page or ext4* at all, at least not for the last
couple minutes on my test box.

I wonder if ext4 changed its handling of fallocated extents somewhere
between 3.5 and 3.9.  In any case, please consider these patches
withdrawn for the time being.

* With file_update_time stubbed out.  I need to dust off my old
patches to fix that part.
