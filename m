Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbaIKALX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 20:11:23 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:39811 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752802AbaIKALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 20:11:22 -0400
Message-ID: <5410E8A2.5030802@hurleysoftware.com>
Date: Wed, 10 Sep 2014 20:11:14 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
References: <1410384499-4982-1-git-send-email-peter@hurleysoftware.com> <20140911000343.GA5328@kroah.com>
In-Reply-To: <20140911000343.GA5328@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2014 08:03 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 10, 2014 at 05:28:19PM -0400, Peter Hurley wrote:
>> This patch changes user-space behavior (for the better) but I'm not sure
>> that it's consequence-free. Also, it might not be enough to unwedge the
>> terminal if the driver got its own flow control state mangled.
>>
>> Thoughts?
>>
>> --- >% ---
>> Subject: [RFC] tty: Always allow tcflow(TCOON) to unwedge terminal
>>
>> If terminal flow has been stopped, the terminal can be unwedged
>> by:
>> 	tcflow(fd, TCOOFF);
>> 	tcflow(fd, TCOON);
>> This works because tcflow(TCOOFF) ensures that ->flow_stopped is set,
>> which allows tcflow(TCOON) to override the terminal flow state in
>> __start_tty().
>>
>> Instead, allow unwedging with only:
>>         tcflow(fd, TCOON);
>> by disregarding the existing ->flow_stopped state.
> 
> I don't see the benifit here, what are you trying to solve?  Sending one
> extra tcflow command?

It's not common knowledge (and its certainly counterintuitive) that
turning off output when output is already turned off (ie., tcflow(TCOOFF))
is the required trickery to unwedge a terminal.

Unwedging directly seems the straightforward approach.

Regards,
Peter Hurley

