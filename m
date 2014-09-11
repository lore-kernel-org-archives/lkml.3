Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbaIKPk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 11:40:26 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49738 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751146AbaIKPkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 11:40:25 -0400
Message-ID: <5411C264.8000105@hurleysoftware.com>
Date: Thu, 11 Sep 2014 11:40:20 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com> <20140911000343.GA5328@kroah.com> <5410E8A2.5030802@hurleysoftware.com> <20140911002410.GA11732@kroah.com> <5410F08D.10707@hurleysoftware.com> <20140911135610.GD15632@thunk.org>
In-Reply-To: <20140911135610.GD15632@thunk.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 09:56 AM, Theodore Ts'o wrote:
> On Wed, Sep 10, 2014 at 08:45:01PM -0400, Peter Hurley wrote:
>>> I'm all for working around broken hardware in the kernel, but this seems
>>> like a very old issue, if it's even one at all, that we would be
>>> changing for no one who has reported it (that I know of...)
>>
>> How to unwedge a terminal comes up from time to time.
> 
> Are you trying to unwedge a terminal using hardware flow control, or
> software flow control?

For unwedging software flow control.

Like you point out, unwedging hardware flow control would be more complicated
and less predictable.

> For software flow control, this is a guarantee that we can make wrt to
> the behavior of tcflow().  For hardware flow control, we can't make
> any guarantees, whether it's with tcflow(TCOON) or tcflow(TCOOF);
> tcflow(TCOON). 
> 
>> It's possible that this may cause userspace breakage. Some app
>> may call tcflow(TCOON) thus accidently overriding the flow control
>> state when it would have had no effect before.
> 
> It's very likely that an application that would be using tcflow() at
> all would first be sending a TCOOFF, and then sending a TCOON.  So
> this doesn't worry me that much.
> 
> Indeed, given that the definition of how TCION and TCIOFF is worded
> (send a START or STOP command), it's completely reasonable to
> interpret TCOON and TCOOFF as emulating what would happen if the
> system received a START or STOP command.  (Note though that part of
> this is that Posix doesn't define CRTSCTS, so POSIX is entirely silent
> on the subject of hardware flow control).

This is the basic interpretation I assumed, and most of what the tty core
already did.

Regards,
Peter Hurley
