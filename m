Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab3FZHYS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 03:24:18 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:45600 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3FZHYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 03:24:17 -0400
Message-ID: <51CA9700.3040600@ahsoftware.de>
Date: Wed, 26 Jun 2013 09:23:44 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Dean Jenkins <Dean_Jenkins@mentor.com>
CC: Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Gustavo Padovan <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org
Subject: Re: BUG: tty: memory corruption through tty_release/tty_ldisc_release
References: <519480A1.6030909@ahsoftware.de> <5194E380.1030109@hurleysoftware.com> <5194E64A.3040003@ahsoftware.de> <5195553C.90608@hurleysoftware.com> <5195B561.3090503@ahsoftware.de> <51C9A6A9.3000202@mentor.com>
In-Reply-To: <51C9A6A9.3000202@mentor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 25.06.2013 16:18, schrieb Dean Jenkins:
> On 17/05/13 05:43, Alexander Holler wrote:

>> To reproduce it, call rfcomm connect /dev/rfcommN and after the
>> connection to the remote device happened, power down the remote device
>> and wait 20s (the timeout until a connection drop will be discovered).
> I expect this behaviour depends on the remote device. Does the device
> close the RFCOMM session cleanly ? Perhaps an out of range test would be
> better so that the connection drops.

Yes. With power down I meant a hard power down, such that the remote 
doesn't has the chance to close the session cleanly. It's easier to do 
than putting it out of range, at least if the remote isn't a 
battery-powered device. I should have described that more clearly.

> Is there a bugzilla bug report that is tracking this issue ? If I can
> reproduce this issue then I would like to add more information to a bug
> report.

I haven't written a bugzilla bug report and won't write one.

Furthermore I've already found and described the problem, so more crash 
reports should not be necessary.

And they don't make much sense because they happen because of a 
disastreous memory corruption, which means the BUGs can include almost 
everything (hopefully nothing which eats your disk contents).

Regards,

Alexander Holler

