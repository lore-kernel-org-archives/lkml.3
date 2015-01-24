Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbbAXB11 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 20:27:27 -0500
Received: from mail2.vodafone.ie ([213.233.128.44]:46754 "EHLO
	mail2.vodafone.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbbAXB1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 20:27:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFAMXzwlRtTfQc/2dsb2JhbABagwbNawKBFUMBAQEBAX2EDQEFMgFGEAsNCwklDwJGBgEMAQUCAQGILAHDXY5tAQEBAQYBAQEBAR2PeAeEKQEEmSKFNQuLZyKDbj4xgkIBAQE
Message-ID: <54C2F4F8.20809@draigBrady.com>
Date: Sat, 24 Jan 2015 01:27:20 +0000
From: =?windows-1252?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>,
        David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] modsign: overwrite keys with zero before deleting them
References: <1422050221-28345-1-git-send-email-holler@ahsoftware.de> <1421976009-9819-1-git-send-email-holler@ahsoftware.de> <6705.1422057490@warthog.procyon.org.uk> <54C2E3AB.9000008@ahsoftware.de>
In-Reply-To: <54C2E3AB.9000008@ahsoftware.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/15 00:13, Alexander Holler wrote:
> Am 24.01.2015 um 00:58 schrieb David Howells:
>> Alexander Holler <holler@ahsoftware.de> wrote:
>>
>>> This is for the more paranoid people, also it's
>>> questionable what paranoid nowadays means.
>>
>> shred?
> 
> Seems to do the same like when using dd, just that it does it moultiple
> times.
> 
> And according to an article I've read some years ago, overwrriting a
> blocks on harddisks multiple times doesn't really make sense because
> doing it just once is enough (the necessity to do it multiple times
> seems to have been one of these unexplainable myths in the IT) .
> 
> So I've no idea if it's worth to use shred and have no idea if it's part
> of any GNU/Linux system (seems likely as it it's part of coreutils), how
> it's maintained and how long it will be available.
> 
> But if requested, I will replace that dd with shred or just feel free to
> do it yourself.

shred is in the same package as dd (coreutils).
It's a bit more paranoid about syncing.
It also tries to write the exact size of the file,
and then rounded up block sizes to decrease the
chance of file system reallocation.
Agreed on the multiple writes being quite futile these days.
Generally overwriting with dd or shred etc. is only useful
at the device level rather than at the file system level.
Anyway to be slightly more paranoid and explicit you could:

  shred -n1 ./signing_key.priv

Pádraig.

