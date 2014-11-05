Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751705AbaKETgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:36:50 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48261 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270AbaKETgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:36:45 -0500
MIME-Version: 1.0
X-Originating-IP: [46.139.80.5]
In-Reply-To: <20141105165833.GE5902@madcap2.tricolour.ca>
References: <20141104102712.GA7088@tucsk.piliscsaba.szeredi.hu>
	<20141105165833.GE5902@madcap2.tricolour.ca>
Date: Wed, 5 Nov 2014 20:36:44 +0100
Message-ID: <CAJfpeguyGSPp+g1SgwAY3aieB=6Z4d5qb72tOTd6oZ-2JFgsfQ@mail.gmail.com>
Subject: Re: [PATCH] audit_tree: keep inode pinned
From: Miklos Szeredi <miklos@szeredi.hu>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-audit@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 5:58 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> On 14/11/04, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>
> Hi Miklos,
>
>> Audit rules disappear when an inode they watch is evicted from the cache.
>> This is likely not what we want.
>>
>> The guilty commit is "fsnotify: allow marks to not pin inodes in core",
>> which didn't take into account that audit_tree adds watches with a zero
>> mask.
>>
>> Adding any mask should fix this.
>
> Nice find!  Do you have a quick reproducer to detect this?


- reboot
- add tree rule
- echo 2 > /proc/sys/vm/drop_caches

drop_caches doesn't guarantee dropping the inode from the cache, but
after a reboot it usually does.

Thanks,
Miklos
