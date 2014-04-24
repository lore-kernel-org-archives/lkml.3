Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbaDXKpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 06:45:51 -0400
Received: from mail-ee0-f54.google.com ([74.125.83.54]:43066 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbaDXKpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 06:45:45 -0400
Date: Thu, 24 Apr 2014 12:45:40 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Dave Young <dyoung@redhat.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, akpm@linux-foundation.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ignore ,keep for efi earlyprintk
Message-ID: <20140424104540.GA5834@gmail.com>
References: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424093658.GA7158@dhcp-16-198.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Young <dyoung@redhat.com> wrote:

> earlyprint=efi,keep results a kernel hang after "Freeing unused kernel memory"

That's a bug.

> 
> Actually efi earlyprintk is using __init functions such as early_ioremap etc.
> Thus efi earlyconsole can not be kept.
> 
> So just ignore it and give out a warning to user.

So, bugs should be fixed, not worked around.

earlyprintk=,keep is really useful for the occasional difficult low 
level bug in the printk code or similar, because earlyprintk is a 
completely separate code path from printk().

Thanks,

	Ingo
