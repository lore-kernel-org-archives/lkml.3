Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629AbaD0Rcr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:32:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35389 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaD0Rcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:32:46 -0400
Date: Sun, 27 Apr 2014 10:33:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 00/47] Lustre fixes and cleanups
Message-ID: <20140427173331.GA11038@kroah.com>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:24PM -0400, Oleg Drokin wrote:
> Hello!
> 
>    This pile of patches brings in most of the recent fixes from
>    current Lustre development tree, also code cleanups, junk removal
>    and such.
>    A relatively unsynced area remaining is in client io stack
>    that is undergoing some major shakeups now, I'll try to tackle
>    it later once things actually settle down some more.

I've applied these, except for the 3 gss patches.

Also, there is now a build warning in the tree thanks to these, please
send a follow-on patch to fix it before you get an email from the 0-day
bot about it.

>    There are several checkpatch warnings in this patchset that
>    I am not sure what to do aobut since the messages printed are
>    genuinely long:
> 
> WARNING: quoted string split across lines
> #61: FILE: drivers/staging/lustre/lustre/ptlrpc/import.c:1424:
> +		CERROR("%s: don't know how to disconnect from %s "
> +		       "(connect_op %d): rc = %d\n",
> 
> total: 0 errors, 1 warnings, 73 lines checked

Strings all need to go on one line, and you all need to take out your
"special" logging macros so that checkpatch will know what to do with
them.

thanks,

greg k-h
