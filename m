Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274AbaJQMoP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 08:44:15 -0400
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:42154 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750729AbaJQMoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 08:44:14 -0400
Message-ID: <54410F19.3040607@hurleysoftware.com>
Date: Fri, 17 Oct 2014 08:44:09 -0400
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -next 05/10] tty: Document defunct ASYNC_* bits in uapi
 header
References: <1413492867-20679-1-git-send-email-peter@hurleysoftware.com> <1413492867-20679-6-git-send-email-peter@hurleysoftware.com> <5440D781.1080308@suse.cz>
In-Reply-To: <5440D781.1080308@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On 10/17/2014 04:46 AM, Jiri Slaby wrote:
> On 10/16/2014, 10:54 PM, Peter Hurley wrote:
>> Note the serial_struct flags for which the kernel ignores and performs
>> no action. The flags cannot be removed since they form part of the
>> userspace interface via the TIOCSSERIAL/TIOCGSERIAL ioctls.
> 
> Hello,
> 
> would it make sense to mark them deprecated somehow? At build time

A build warning when the macro is expanded would be best, but my
c-preprocessor-fu is terrible, so I have no idea how to make that work.

> or
> at least warn in the serial core that "current->comm is using a
> deprecated flag"_ratelimited()?

If we just print the message at TIOCSSERIAL if any of the deprecated
bits are set, that would be ok. Probably the only issue would be that
setserial could cause this message at will, so log flooding would be
a concern.

Regards,
Peter Hurley

