Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbaDVNxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 09:53:00 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:38817 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbaDVNwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 09:52:53 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAKgNAkh=Shj6UO6x_KieQEYUoY+guokNute0iwUfiSYFJbeTfQ@mail.gmail.com>
References: <1397940833-6386-1-git-send-email-xypron.glpk@gmx.de>
 <20140422134044.GE366@quack.suse.cz> <CAKgNAkh=Shj6UO6x_KieQEYUoY+guokNute0iwUfiSYFJbeTfQ@mail.gmail.com>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Tue, 22 Apr 2014 15:52:32 +0200
Message-ID: <CAKgNAkiS+VdFNy4Z3G+U0ck5r4vXPt5goptnQHQzEsF+tGVWoQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] fanotify: check permissions when creating file descriptor
To: Jan Kara <jack@suse.cz>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>, Eric Paris <eparis@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 3:50 PM, Michael Kerrisk (man-pages)
<mtk.manpages@gmail.com> wrote:
> On Tue, Apr 22, 2014 at 3:40 PM, Jan Kara <jack@suse.cz> wrote:
>> On Sat 19-04-14 22:53:53, Heinrich Schuchardt wrote:
>>> When monitoring a directory or a mount with the fanotify API
>>> the call to fanotify_init checks,
>>>  * the process has cap_sys_admin capability
>>>
>>> The call to fanotify_mark checks,
>>>  * the process has read authorization for directory or mount
>>>
>>> A directory or mount may contain files for which the process
>>> has no read or write authorization.
>>> Yet when reading from the fanotify file descriptor, structures
>>> fanotify_event_metadata are returned, which contain a file
>>> descriptor for these files, and will allow to read or write.
>>>
>>> The patch adds an authorization check for read and write
>>> permission. In case of missing permission, reading from the
>>> fanotify file descriptor returns EACCES.
>>   OK, am I right you are concerned about a situation where fanotify group
>> descriptor is passed to an unpriviledged process which handles all the
>> incoming events? I'm asking because the permission checking can be
>> relatively expensive (think of acls) so we better do it for a reason.
>> I'd prefer to hear from Eric what the original intention regarding
>> permissions was...
>
> If I understand correctly, passing to an unprivileged process is the

sorry: s/is the/is not the/
