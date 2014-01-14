Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbaANJ64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 04:58:56 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:59891 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaANJ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 04:58:52 -0500
MIME-Version: 1.0
X-Originating-IP: [86.59.245.170]
In-Reply-To: <201401140703.ICH21836.HMJStQVFOFOLOF@I-love.SAKURA.ne.jp>
References: <1389219015-10980-1-git-send-email-miklos@szeredi.hu>
	<201401132146.BAF65659.QJSOFVOtFHMOFL@I-love.SAKURA.ne.jp>
	<1389632933.16290.15.camel@tucsk.piliscsaba.szeredi.hu>
	<201401140703.ICH21836.HMJStQVFOFOLOF@I-love.SAKURA.ne.jp>
Date: Tue, 14 Jan 2014 10:58:50 +0100
Message-ID: <CAJfpegs6kzkmJ8NFCuwEBGFgW5toM4X9RC+8JzJPX1V1rMmsow@mail.gmail.com>
Subject: Re: [PATCH 00/11] cross rename v3
From: Miklos Szeredi <miklos@szeredi.hu>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: "mszeredi@suse.cz" <mszeredi@suse.cz>, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Zach Brown <zab@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:03 PM, Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
> Miklos Szeredi wrote:
>> Cross rename (A, B) is equivalent to plain rename(A, B) + plain rename
>> (B, A) done as a single atomic operation.  If security module allows
>> both then cross rename is allowed.  If at least one is denied then the
>> cross rename is denied.
>
> Yes, the functionality itself is fine. The problem is how LSM users check
> their permissions for the functionality.
>
>>
>> This is prepared for in "[PATCH 06/11] security: add flags to rename
>> hooks" and actually done in "[PATCH 07/11] vfs: add cross-rename".
>>
>> Security people are free to implement a explicit security check for
>> cross rename, but I don't think that is in the scope of this patchset.
>>
> I don't know how their permissions are checked, but I think that
> swapping /A/B and /C/D should check not only
>
>   Remove a name from directory A
>   Add a name to directory C
>
> but also
>
>   Add a name to directory A
>   Remove a name from directory C
>
> using their security labels.
>
> Without making changes to security/*/ directory, SELinux/SMACK/TOMOYO/AppArmor
> might fail to check the latter permissions.

Those permissions will be checked.   Please see security/security.c in
patch 07/11 of the series.

Of course, review is appreciated.

Thanks,
Miklos
