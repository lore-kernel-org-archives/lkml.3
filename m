Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab3LINTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:19:23 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:35259 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932631Ab3LINTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:19:20 -0500
Message-ID: <52A5C354.5050600@hurleysoftware.com>
Date: Mon, 09 Dec 2013 08:19:16 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Karl Dahlke <eklhad@comcast.net>
CC: Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com> <20131209011220.GA7671@kroah.com>
In-Reply-To: <20131209011220.GA7671@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2013 08:12 PM, Greg Kroah-Hartman wrote:
> On Mon, Dec 02, 2013 at 04:12:01PM -0500, Peter Hurley wrote:
>> Greg,
>>
>> Sometimes when interrupting terminal output, the '^C' won't be echoed
>> until more output is echoed. This is fairly repeatable by interrupting
>> 'cat large-file'.
>>
>> The common reason for this is because the tty write buffer is full,
>> even though the write buffer _should_ have been flushed already.
>> Because of a known deadlock, the pty driver does not perform a
>> write buffer flush in its flush_buffer() method.
>>
>> [Refer to the FIXME in pty_flush_buffer() from commit
>> d945cb9cce20ac7143c2de8d88b187f62db99bdc,
>> 'pty: Rework the pty layer to use the normal buffering logic']
>>
>> Patch 1 fixes a stale comment.
>> Patch 2 adds the necessary interfaces to avoid direct linkage
>> between the N_TTY line discipline and the pty driver.
>> Patch 3 avoids the deadlock while performing the write buffer flush.
>> Patch 4 fixes a less common condition introduced by the echo batch
>> processing added in 3.12.
>>
>> Alan,
>>
>> I cc'd you because of your recent involvement in other
>> tty patches/bug fixes and because it's your FIXME comment.
>> Feel free to ignore and/or let me know you would prefer not to
>> be bothered.
>
> Peter, this series doesn't fix the ^C echo problem that Karl recently
> reported, so I'll hold off in applying it for now.

Yeah, please discard this. It does fix some problems but I don't really
like how it goes about fixing them. I've been exploring some ideas
based on my discussion with Alan but nothing fruitful yet.

Regards,
Peter Hurley

