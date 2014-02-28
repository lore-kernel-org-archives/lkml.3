Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaB1OOV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 09:14:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60882 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751495AbaB1OOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 09:14:20 -0500
Message-ID: <531099BA.9080901@suse.de>
Date: Fri, 28 Feb 2014 15:14:18 +0100
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@gmail.com>, linux-kernel@vger.kernel.org
CC: Ray Strode <halfline@gmail.com>, Werner Fink <werner@suse.de>,
        Peter Hurley <peter@hurleysoftware.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v3] tty: Set correct tty name in 'active' sysfs attribute
References: <1393500651-1064-1-git-send-email-dh.herrmann@gmail.com>
In-Reply-To: <1393500651-1064-1-git-send-email-dh.herrmann@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2014 12:30 PM, David Herrmann wrote:
> From: Hannes Reinecke <hare@suse.de>
> 
> The 'active' sysfs attribute should refer to the currently active tty
> devices the console is running on, not the currently active console. The
> console structure doesn't refer to any device in sysfs, only the tty the
> console is running on has. So we need to print out the tty names in
> 'active', not the console names.
> 
> There is one special-case, which is tty0. If the console is directed to
> it, we want 'tty0' to show up in the file, so user-space knows that the
> messages get forwarded to the active VT. The ->device() callback would
> resolve tty0, though. Hence, treat it special and don't call into the VT
> layer to resolve it (plymouth is known to depend on it).
> 
> Cc: Lennart Poettering <lennart@poettering.net>
> Cc: Kay Sievers <kay@vrfy.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Signed-off-by: Werner Fink <werner@suse.de>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
> ---
> v2: use cs[i]->index instead of ->index
>     refactor code to avoid >80 lines
>     split out sprintf("%c",...);
> 
> Tested on my x86-64 machine.

Thanks for this.
Patch looks good.

Acked-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
