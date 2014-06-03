Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614AbaFCRse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:48:34 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:55099 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaFCRsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:48:33 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxfEsOZreYBCrDTfgaSf0441zXf4uSmzsYU-JXHBRkzJg@mail.gmail.com>
References: <CALCETrXbpiqwY=qyPcNWn2zX=vehXzBbxDG725egM9T2Ox2KTA@mail.gmail.com>
 <538D2261.70406@huawei.com> <20140603012211.GE19855@htj.dyndns.org>
 <CA+55aFx=TG25jPohWZ5xbYs4DcOTUQnCPA8G_fZZouNEfSoZ3A@mail.gmail.com> <CA+55aFxfEsOZreYBCrDTfgaSf0441zXf4uSmzsYU-JXHBRkzJg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 3 Jun 2014 10:48:11 -0700
Message-ID: <CALCETrXKbDb-ww+52OWzXMzYDXdFxFZczsKCFOdcEyw2vSy1EQ@mail.gmail.com>
Subject: Re: 3.15 regression: wrong cgroup magic
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jianyu Zhan <nasa4836@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 3, 2014 at 10:23 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jun 2, 2014 at 6:30 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Of course, Greg could just send it to me for my next branch (since the
>> merge window for 3.16 is already open) and tell me that it's also
>> stable material for 3.15. At _that_ point I'll happily cherry-pick it
>> into master...
>
> Ok, so that happened.
>
> Tejun, just to be anal, can you please test and verify current -git
> (preferably both 'master' and 'next') with your app that cared about
> the f_type information for statfs()..

Did you mean me?

My code seems to work now, and strace says:

fstatfs(6, {f_type=0x27e0eb, f_bsize=4096, f_blocks=0, f_bfree=0, f_bavail=0, f_
files=0, f_ffree=0, f_fsid={0, 0}, f_namelen=255, f_frsize=4096}) = 0

which is consistent with:

#define CGROUP_SUPER_MAGIC      0x27e0eb

This is on master.  I'll test next eventually.

Thanks everyone!

--Andy
