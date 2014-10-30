Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbaJ3NtE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:49:04 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:45045 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759768AbaJ3NtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:49:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAG-2HqUChohNrRSdXzckSiv8ZUYwFLMvRTc41Uo7-b-qmkSFMQ@mail.gmail.com>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <CALCETrWrxc8foPYbRPtxwNX0sHK_=vLFLDXXyXu+2U2=B+=qCQ@mail.gmail.com>
 <20141029222729.GB8129@kroah.com> <CALCETrVxvF2ie=vVgpjeqikn+nci_9jyKfU4s3t=4cjyNZNaNQ@mail.gmail.com>
 <87bnourxx4.fsf@x220.int.ebiederm.org> <CAG-2HqUChohNrRSdXzckSiv8ZUYwFLMvRTc41Uo7-b-qmkSFMQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 30 Oct 2014 06:48:40 -0700
Message-ID: <CALCETrX+Pzyrbct2Pe2m+ADXozWCr2rRKv9UPg=7o8bn-A4rzQ@mail.gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
To: Tom Gundersen <teg@jklm.no>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>,
        Simon McVittie <simon.mcvittie@collabora.co.uk>,
        Daniel Mack <daniel@zonque.org>, alban.crequy@collabora.co.uk,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 3:15 AM, Tom Gundersen <teg@jklm.no> wrote:
> Do I understand you correctly that what you want is unnamed/anonymous
> domains? Considering that domain creation is anyway privileged, why is
> this necessary?

As an executive summary, this is the *problem*, not a mitigation.
Domain creation *should not require privilege*.  You should be able to
do it in a user namespace in which you have appropriate capabilities
without needing systemd's (or whatever other daemon's) help from
outside.

Once you fix that (which may not have broken whatever you tested with
but will absolutely break anyone who tries to use this in LXC, Docker,
Sandstorm, etc. without awful hacks) then you will have all of the
problems that you've currently mitigated.

--Andy
