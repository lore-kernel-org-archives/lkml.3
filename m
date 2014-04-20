Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751400AbaDTWWf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2014 18:22:35 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:44779 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751039AbaDTWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2014 18:22:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
	<20140417212834.GC17769@csclub.uwaterloo.ca>
	<CAHO5Pa1Rb5YkXF_0iE_KUhOOGeNo+zV+OWQW6L8_ix=iFvkTyg@mail.gmail.com>
Date: Mon, 21 Apr 2014 00:22:32 +0200
Message-ID: <CAFLxGvxx8_gJ+NAGVn_vZmkVfey45_1qTqAQnxKDCZD0gQsr5w@mail.gmail.com>
Subject: Re: inotify, new idea?
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
        Jos Huisken <jos.huisken@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, 2014 at 6:15 AM, Michael Kerrisk <mtk.manpages@gmail.com> wrote:
> On Thu, Apr 17, 2014 at 11:28 PM, Lennart Sorensen
> <lsorense@csclub.uwaterloo.ca> wrote:
>> On Thu, Apr 17, 2014 at 11:00:37PM +0200, Jos Huisken wrote:
>>> I was trying to maintain a local and remote directory in sync with
>>> lsync, using inotify.
>>> I happen to have >4M files and >400k directories... running over
>>> /proc/sys/fs/inotify/max_user_watches
>>
>> Would fanotify perhaps be a better interface to use?
>
> (One of us is misunderstanding fanotify; it might be me.)
>
> Did you look at fanotify closely? I don't think it could be used for
> this task -- does not notify linka dn unlink events, difficult to set
> up recursive monitoring, etc.

Does recursive monitoring even work with inotify?
Last time I've tried it did failed as soon I did a mkdir -p a/b/c/d because
mkdir() raced against the thread which installes the new watches.

-- 
Thanks,
//richard
