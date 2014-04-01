Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbaDAN2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:28:48 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:64585 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbaDAN2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:28:46 -0400
MIME-Version: 1.0
In-Reply-To: <533ABCCB.4090502@oracle.com>
References: <CA+5PVA67oBeHUiPXj0viNgrX+uDnJ9LsZSPXF1cLt_D511KKtA@mail.gmail.com>
	<533ABCCB.4090502@oracle.com>
Date: Tue, 1 Apr 2014 09:28:46 -0400
X-Google-Sender-Auth: RjY4LyZZSZKy-T0lvefwwXubV8E
Message-ID: <CA+5PVA7eiCX_DHqkFx8t86naqs6o=rVcm0Ok5E2Pw9kXhSD_jg@mail.gmail.com>
Subject: Re: liblockdep soname versioning
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 1, 2014 at 9:19 AM, Sasha Levin <sasha.levin@oracle.com> wrote:
> On 04/01/2014 08:56 AM, Josh Boyer wrote:
>>
>> Hi Sasha,
>>
>> We've had a request [1] to package up liblockdep in Fedora.  Looking
>> things over, I noticed the library isn't actually versioned at all and
>> instead just builds a plain .so file.  That's likely fine during
>> development of it, but if distros are to ship it for broader use then
>> it would be a good idea to specify the soname and use a versioned .so.
>>
>> The makefile already has LIBLOCKDEP_VERSION defined.  Would it be
>> possible to use this as the soname and version number?  Then
>> liblockdep.so could be the normal symlink to the versioned .so
>> (liblockdep.so.0.0.1 in this case).
>>
>> Thanks.
>>
>> josh
>>
>> [1] https://bugzilla.redhat.com/show_bug.cgi?id=1082763
>>
>
> Sure! I never expected it to live outside the kernel tree as a separate
> package, but I'm happy to accommodate for that.
>
> I think that I'll just match the version number with the kernel version
> since what mostly matters is what you have in kernel/lockdep.c, so for
> example, right now we'll have 'liblockdep.so.3.15.0'. Sounds good?

The only concern I would have is that it would require applications
linking to it to rebuild with every kernel release even if nothing
else changed.  Maybe nothing changing is going to be rare enough that
in practice people will need to rebuild anyway.  Either way, it's
better to be explicit rather than break users silently, so it sounds
good to me.

josh
