Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762255Ab3ECCRE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 22:17:04 -0400
Received: from mail-vc0-f173.google.com ([209.85.220.173]:53248 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760599Ab3ECCRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 22:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130503000358.GX19814@mtj.dyndns.org>
References: <1367458508-9133-1-git-send-email-ccross@android.com>
	<1367458508-9133-4-git-send-email-ccross@android.com>
	<20130502235505.GW19814@mtj.dyndns.org>
	<20130503000358.GX19814@mtj.dyndns.org>
Date: Thu, 2 May 2013 19:16:59 -0700
X-Google-Sender-Auth: 0rXgfmv36oI8jTI7mstFxKJLKjU
Message-ID: <CAMbhsRSFjUvkXq66pYs_nYN5At7yB4sFM+cpxLgUF_Yns54J5A@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] freezer: add new freezable helpers using freezer_do_not_count()
From: Colin Cross <ccross@android.com>
To: Tejun Heo <tj@kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Oleg Nesterov <oleg@redhat.com>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This sounds the same as what ended up getting reverted in
https://lkml.org/lkml/2013/3/4/221
I can add the WARN_ON_ONCE to all my new calls, and leave them out of
existing calls, but that seems a little odd, and will be redundant if
the lockdep call in try_to_freeze goes back in in 3.11.  Do you still
want it in the new apis?

On Thu, May 2, 2013 at 5:03 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, May 02, 2013 at 04:55:05PM -0700, Tejun Heo wrote:
>> So, the freezable interface can't be something that people can use
>> casually.  It is something which should be carefully and strategically
>> deployed where we *know* that lock dependency risks don't exist or at
>> least are acceptable.  I'm a bit weary that this patch is expanding
>> the interface a lot that they now look like the equivalents of normal
>> schedule calls.  Not exactly sure what to do here but can we please at
>> least have RED BOLD BLINKING comments which scream to people not to
>> use these unless they know what they're doing?
>
> Maybe we should trigger WARN_ON_ONCE() if lockdep_depth() > 0 by
> default and have ugly variants which can be used if the caller is sure
> that it's okay possibly with list of locks which are held?
>
> --
> tejun
