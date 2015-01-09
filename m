Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbbAIWBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 17:01:05 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:55432 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbbAIWBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 17:01:02 -0500
Message-ID: <54B04F97.7070200@hurleysoftware.com>
Date: Fri, 09 Jan 2015 17:00:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Francesco Ruggeri <fruggeri@aristanetworks.com>,
        Francesco Ruggeri <fruggeri@arista.com>
Subject: Re: [PATCH] Revert "tty: Fix pty master poll() after slave closes
 v2"
References: <1419941829-6536-1-git-send-email-peter@hurleysoftware.com> <54A29B0A.3060707@hurleysoftware.com> <20150109214106.GA7952@kroah.com>
In-Reply-To: <20150109214106.GA7952@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2015 04:41 PM, Greg Kroah-Hartman wrote:
> On Tue, Dec 30, 2014 at 07:31:06AM -0500, Peter Hurley wrote:
>> On 12/30/2014 07:17 AM, Peter Hurley wrote:
>>> This reverts commit c4dc304677e8d566572c4738d95c48be150c6606.
>>> This fix is superseded by commit 52bce7f8d4fc633c9a9d0646eef58ba6ae9a3b73,
>>> 'pty, n_tty: Simplify input processing on final close'.
>>>
>>> The final close now waits for input processing to complete before
>>> destroying the pty, so poll() does not need to special case this
>>> condition.
>>
>> Greg,
>>
>> As noted in this commit log, commit c4dc304677e8d566572c4738d95c48be150c6606,
>> 'tty: Fix pty master poll() after slave closes v2', is not required
>> after commit 52bce7f8d4fc633c9a9d0646eef58ba6ae9a3b73,
>> 'pty, n_tty: Simplify input processing on final close'
>>
>> However, 'tty: Fix pty master poll() after slave closes v2' is appropriate
>> for stable back to v3.12.
> 
> I don't understand, what needs to go to a stable tree and what doesn't?

Commit c4dc304677e8d5665 ("tty: Fix pty master poll() after slave closes v2")
goes to stable v3.12~v3.18, but not 3.19-rc1+

Regards,
Peter Hurley
