Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751851AbaKET7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:59:38 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:60838 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751746AbaKET7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:59:34 -0500
Date: Wed, 5 Nov 2014 20:59:30 +0100
From: Djalal Harouni <tixxdz@opendz.org>
To: Simon McVittie <simon.mcvittie@collabora.co.uk>
Cc: Andy Lutomirski <luto@amacapital.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Daniel Mack <daniel@zonque.org>,
        "alban.crequy" <alban.crequy@collabora.co.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tom Gundersen <teg@jklm.no>
Subject: Re: kdbus: add code for buses, domains and endpoints
Message-ID: <20141105195929.GA3624@dztty>
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org>
 <1414620056-6675-9-git-send-email-gregkh@linuxfoundation.org>
 <8738a6w6kv.fsf@x220.int.ebiederm.org>
 <20141030095854.GA4716@dztty>
 <87wq7hiwjb.fsf@x220.int.ebiederm.org>
 <20141030144855.GA9705@dztty>
 <CALCETrXeNQUuwiyaJrbbbZUrSW3NTucRgpg0kKEuS3yszP-09w@mail.gmail.com>
 <20141030180813.GA11850@dztty>
 <54528798.40107@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54528798.40107@collabora.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 06:46:48PM +0000, Simon McVittie wrote:
> On 30/10/14 18:08, Djalal Harouni wrote:
> > So, this is similar to AF_UNIX sockets. For them there's SCM_CREDENTIALS
> > and SO_PEERCRED. The former uses credentials at the time of when
> > messages are being sent, the latter uses the credentials at the time
> > when when the connection was initially established.
> 
> Please note that dbus-daemon, the reference implementation of D-Bus,
> does not actually ever use SCM_CREDENTIALS on its AF_UNIX sockets. We
> prefer to use Linux's SO_PEERCRED, or the platform's closest available
> equivalent if there is one. dbus-daemon has methods (RPC calls) to get a
> specified peer's uid, pid or LSM data (e.g. SELinux context), but those
> methods return the value that was true when the connection was opened or
> shortly afterwards, not the value that is true right now. I believe the
> plan is that kdbus has ioctls that are equivalent to those RPC calls,
> but without needing to wait for asynchronous socket events to get an answer.
Correct, we are compatible to SO_PEERCRED and every peer can request
that using KDBUS_CMD_CONN_INFO ioctl(), no need for asynchronous
operations.

Thank you Simon for your feedback!

-- 
Djalal Harouni
http://opendz.org
