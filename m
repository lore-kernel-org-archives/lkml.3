Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbaGHVuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:50:32 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:61447 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbaGHVub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:50:31 -0400
Date: Wed, 9 Jul 2014 00:50:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/2] proc: faster /proc/$PID lookup
Message-ID: <20140708215029.GC2382@p183.telecom.by>
References: <20140708214041.GA2256@p183.telecom.by>
 <20140708214557.GB2256@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708214557.GB2256@p183.telecom.by>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 12:45:57AM +0300, Alexey Dobriyan wrote:
> Currently lookup for /proc/$PID first goes through spinlock and
> whole list of misc /proc entries only to confirm that, yes,
> /proc/42 can not possibly match random proc entry.
> 
> List is is several dozens entries long (52 entries on my setup).
> 
> None of this is necessary.
> 
> Try to convert dentry name to integer first.
> If it works, it must be /proc/$PID.
> If it doesn't, it must be random proc entry.

Recycled from Al Viro's patch as well!
