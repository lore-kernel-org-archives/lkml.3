Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063AbaGINUx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:20:53 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60835 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbaGINUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:20:52 -0400
Date: Wed, 9 Jul 2014 14:20:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: v3.16-rc4 messes up make kernelrelease with additional output
Message-ID: <20140709132047.GT21766@n2100.arm.linux.org.uk>
References: <20140709125955.GS21766@n2100.arm.linux.org.uk> <53BD4074.5070100@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BD4074.5070100@suse.cz>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2014 at 03:15:32PM +0200, Michal Marek wrote:
> On 2014-07-09 14:59, Russell King - ARM Linux wrote:
> > 3.16-rc3 and all previous versions:
> > 
> > $ make ARCH=arm CROSS_COMPILE=arm-linux- O=/tmp/build/ kernelrelease
> > 3.16.0-rc3+
> > $
> > 
> > 3.16-rc4:
> > 
> > $ make ARCH=arm CROSS_COMPILE=arm-linux- O=/tmp/build/ kernelrelease
> > make[1]: Entering directory `/tmp/build'
> > 3.16.0-rc4+
> > $
> 
> This is fixed by commit 066b7ed9 in linux-next, which I'll send to Linus
> shortly. But you should use make -s ... kernelrelease, otherwise the
> output will be polluted not only by the "Entering directory" message,
> but possibly also by a  silentoldconfig run.

Since my scripts run a full build before doing that, it's very unlikely
that there would be a silentoldconfig run.  The -s requirement isn't
documented in the help - should it be?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
