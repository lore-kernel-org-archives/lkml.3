Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbaGINPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 09:15:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbaGINPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 09:15:34 -0400
Message-ID: <53BD4074.5070100@suse.cz>
Date: Wed, 09 Jul 2014 15:15:32 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: v3.16-rc4 messes up make kernelrelease with additional output
References: <20140709125955.GS21766@n2100.arm.linux.org.uk>
In-Reply-To: <20140709125955.GS21766@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-09 14:59, Russell King - ARM Linux wrote:
> 3.16-rc3 and all previous versions:
> 
> $ make ARCH=arm CROSS_COMPILE=arm-linux- O=/tmp/build/ kernelrelease
> 3.16.0-rc3+
> $
> 
> 3.16-rc4:
> 
> $ make ARCH=arm CROSS_COMPILE=arm-linux- O=/tmp/build/ kernelrelease
> make[1]: Entering directory `/tmp/build'
> 3.16.0-rc4+
> $

This is fixed by commit 066b7ed9 in linux-next, which I'll send to Linus
shortly. But you should use make -s ... kernelrelease, otherwise the
output will be polluted not only by the "Entering directory" message,
but possibly also by a  silentoldconfig run.

Michal
