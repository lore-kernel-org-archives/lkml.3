Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351AbaKCRSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:18:24 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:53194 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509AbaKCRSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:18:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141103171515.GB7554@ubuntu-hedt>
References: <1414013060-137148-1-git-send-email-seth.forshee@canonical.com> <20141103171515.GB7554@ubuntu-hedt>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 3 Nov 2014 09:17:58 -0800
Message-ID: <CALCETrUtCsv4MgZ6+U94PO6RLMCWe5S=Y5aVnqFapYnK7YTVRg@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] fuse: Add support for mounts from pid/user namespaces
To: Miklos Szeredi <miklos@szeredi.hu>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge H. Hallyn" <serge.hallyn@ubuntu.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Michael j Theall <mtheall@us.ibm.com>,
        fuse-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 3, 2014 at 9:15 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> On Wed, Oct 22, 2014 at 04:24:16PM -0500, Seth Forshee wrote:
>> Here's another update to the patches to enable userns mounts in fuse.
>> The changes this time around center on xattrs and allow_other. I'm
>> considering the following patch to be a prerequisite for this series:
>>
>> http://lkml.kernel.org/g/252a4d87d99fc2b5fe4411c838f65b312c4e13cd.1413330857.git.luto@amacapital.net
>>
>> With this patch I'm dropping the xattr restrictions from the v4 patches.
>> This leaves the situation with xattrs unchanged in init_user_ns. A fuse
>> userns mount could still supply xattrs which the user would normally be
>> unable to set, but since the mount will be inaccessible outside of that
>> userns or its descendants those xattrs will never be seen by the host.
>>
>> I'm also in agreement with Andy that some decision regarding this patch
>> should be made before merging the fuse userns support as well:
>>
>> http://lkml.kernel.org/g/2686c32f00b14148379e8cfee9c028c794d4aa1a.1407974494.git.luto@amacapital.net
>>
>> Changes since v4:
>>  - Drop patch to restrict xattrs
>>  - Update allow_other to restrict based on userns of current rather than
>>    uid/gid
>
> Miklos, Eric - Any feedback from either of you on these patches?
>

[off-list to avoid further clutter]

Eric's moving, I think, and will be mostly unavailable for a week or two.

--Andy

> Thanks,
> Seth



-- 
Andy Lutomirski
AMA Capital Management, LLC
