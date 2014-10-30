Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbaJ3HoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 03:44:17 -0400
Received: from svenfoo.org ([82.94.215.22]:45899 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbaJ3HoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 03:44:15 -0400
Message-ID: <5451EC4C.3010205@zonque.org>
Date: Thu, 30 Oct 2014 08:44:12 +0100
From: Daniel Mack <daniel@zonque.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Linux API <linux-api@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Tejun Heo <tj@kernel.org>, Marcel Holtmann <marcel@holtmann.org>,
        Ryan Lortie <desrt@desrt.ca>, Bastien Nocera <hadess@hadess.net>,
        David Herrmann <dh.herrmann@gmail.com>,
        Djalal Harouni <tixxdz@opendz.org>, simon.mcvittie@collabora.co.uk,
        alban.crequy@collabora.co.uk, javier.martinez@collabora.co.uk,
        Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 00/12] Add kdbus implementation
References: <1414620056-6675-1-git-send-email-gregkh@linuxfoundation.org> <CALCETrUBegZ4F1sKq3LxUgANX3=syYOrqOp9=F--g9pkVHHgUA@mail.gmail.com> <20141029222531.GA8129@kroah.com> <CALCETrX6vf7cKy=XDhDtn9hn1W930MRxBa=pk93RnyuZ-EaNyw@mail.gmail.com>
In-Reply-To: <CALCETrX6vf7cKy=XDhDtn9hn1W930MRxBa=pk93RnyuZ-EaNyw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2014 11:28 PM, Andy Lutomirski wrote:
> On Wed, Oct 29, 2014 at 3:25 PM, Greg Kroah-Hartman

>> You do have to opt-in for this information at time of capture, so
>> I don't understand the issue here.  This is the same type of thing
>> that dbus does today, and I don't see the information leaks
>> happening there, do you?
> 
> The docs suggest that the *receiver* opts in.

Yes, that's true.

> I don't think that current dbus has severe information leaks because 
> the total scope for information transparently sent to dbus is rather 
> small (struct ucred only, presumably).

Which piece of credential information are you concerned about,
particularly? I might miss something, but AFAICS, all of that
information can be queried by a remote peer anyway, through /proc for
instance. The reason why we (optionally) attach them to messages is that
we want to let the other side know which information was authoritative,
precisely at the time the message was sent. Current implementation can't
do that in a race-free way.

Also note that we currently drop all such metadata whenever a message
crosses a PID or user namespace boundary. This is because we currently
don't know yet which information we would want to transport in such
cases, and how the translation in both directions would look like, from
a semantic perspective. Hence, we decided to leave that for later.

I'll go through your other replies during the day. Thanks for your input
on that RFC, everyone.


Daniel
