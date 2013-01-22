Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3AVQdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:33:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34805 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3AVQdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:33:54 -0500
Message-ID: <50FEBF35.6010502@zytor.com>
Date: Tue, 22 Jan 2013 10:32:53 -0600
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au
Subject: Re: [PATCH 2/2] x86 e820: Introduce memmap=resetusablemap for kdump
 usage
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <1358868049-19884-3-git-send-email-trenn@suse.de> <50FEB620.3020805@zytor.com> <201301221723.03863.trenn@suse.de>
In-Reply-To: <201301221723.03863.trenn@suse.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 10:23 AM, Thomas Renninger wrote:
> This would be wrong. If kexec tries to declare usable memory via memmap=
> which is set to reserved by the BIOS, a WARN_ON() or even better BUG_ON()
> can/should be issued. This is then not possible anymore.

You can't do that anyway, because memmap= is not kexec-specific.

> Your suggestion would again make the e820 data useless. One would again 
> not know whether an area which is reserved really is meant for BIOS/HW
> communication. And for example broken mmconf platforms for which
> the check "is mmconf area is in reserved space" returns false, would now
> try to setup mmconf in kdump case. Do you want to introduce another
> e820 type: KDUMP_RESERVED which formerly was usable? This would preserve
> e820 info, but I cannot see for what this should be good for.

You just answered your own question.  Yes, we already have such "kernel
reserved" types, and we could make a "memmap reserved"

>> Even more sense would be to pass the modified memmap to kexec...
> Not sure what you mean with this. When kexec is called, you are in a 
> kernel which does not have a modified memmap. How can a modified map
> get passed to kexec?

The memory map is simply a data structure which is passed by kexec.  It
can be modified at will by the kexec tools.  This is the Right Way to do
any of this; using the command line is just a horribly fscked up hack in
the first place.

> Again: Please explain what is bad with this solution.
> I cannot see a better and more robust way for kdump other than
> reserving the original reserved memory areas as declared by the BIOS.

It is bad because it creates more complexity than is needed.

The whole point is that what we want is simply to switch type 1 to type
X, with the sole exceptions being the areas explicitly reserved for the
kdump kernel.

	-hpa

