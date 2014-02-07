Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaBGTZR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 14:25:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58633 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbaBGTZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 14:25:15 -0500
Date: Fri, 7 Feb 2014 11:26:25 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Moskyto Matejka <mq@suse.cz>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
        Nathaniel McCallum <nathaniel@natemccallum.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Modpost: fixed USB alias generation for ranges including
 0x9 and 0xA
Message-ID: <20140207192625.GA13470@kroah.com>
References: <1391796911-23456-1-git-send-email-mq@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391796911-23456-1-git-send-email-mq@suse.cz>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 07, 2014 at 07:15:11PM +0100, Jan Moskyto Matejka wrote:
> Commit afe2dab4f6 ("USB: add hex/bcd detection to usb modalias generation")
> changed the routine that generates alias ranges. Before that change, only
> digits 0-9 were supported; the commit tried to fix the case when the range
> includes higher values than 0x9.
> 
> Unfortunately, the commit didn't fix the case when the range includes both
> 0x9 and 0xA, meaning that the final range must look like [x-9A-y] where
> x <= 0x9 and y >= 0xA -- instead the [x-9A-x] range was produced.
> 
> Modprobe doesn't complain as it sees no difference between no-match and
> bad-pattern results of fnmatch().
> 
> Fixing this simple bug to fix the aliases.
> Also changing the hardcoded beginning of the range to uppercase as all the
> other letters are also uppercase in the device version numbers.
> 
> Fortunately, this affects only the dvb-usb-dib0700 module, AFAIK.

Thanks, I'll take this through the usb tree.

Odd that it's taken years for this to show up as an issue.

greg k-h
