Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483AbaJ2WTp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 18:19:45 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:40393 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaJ2WTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 18:19:44 -0400
MIME-Version: 1.0
In-Reply-To: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 15:19:21 -0700
Message-ID: <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com>
Subject: Re: [PATCH 00/12] Add kdbus implementation
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        daniel@zonque.org, alban.crequy@collabora.co.uk,
        javier.martinez@collabora.co.uk, Tom Gundersen <teg@jklm.no>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 29, 2014 at 3:00 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>  * Attachment of trustable metadata to each message on demand, such as
>    the sending peer's timestamp, creds, auxgroups, comm, exe, cmdline,
>    cgroup path, capabilities, security label, audit information, etc,
>    each taken at the time the sender issued the ioctl to send the
>    message. Which of those are actually recorded and attached is
>    controlled by the receiving peer.

I think that each piece of trustable metadata needs to be explicitly
opted-in to by the sender at the time of capture.  Otherwise you're
asking for lots of information leaks and privilege escalations.  This
is especially important given that some of the items in the current
list could be rather sensitive.

NB: UNIX sockets get this wrong, too, but that doesn't mean that kdbus
gets to blindly follow SCM_CREDENTIALS's lead.  Also, there is no
excuse here about legacy code that won't opt in when needed.

--Andy
