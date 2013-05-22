Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab3EVLK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 07:10:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:5582 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab3EVLK4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 07:10:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,719,1363158000"; 
   d="scan'208";a="245081418"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 13/15] chipidea: Allow user to select PCI/IMX options
In-Reply-To: <519C8704.6060901@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <1367936303-13386-13-git-send-email-jslaby@suse.cz> <87k3n9n8ln.fsf@ashishki-desk.ger.corp.intel.com> <5193B0CB.9080608@suse.cz> <87a9nvl10l.fsf@ashishki-desk.ger.corp.intel.com> <519C8704.6060901@suse.cz>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 May 2013 14:10:52 +0300
Message-ID: <87bo838e2r.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> On 05/16/2013 11:36 AM, Alexander Shishkin wrote:
>> The benefit from compiling it on non-arm (or non-imx) architectures for
>> me is compilation testing. We don't have a whole lot of architectures
>> with CONFIG_OF so it's nice to give it a stretch.
>
> Yes, the newly added COMPILE_TEST config option will do the job. Stay
> tuned...

Seems to do the trick.

>> If you really want to save space in your rpm package, I would suggest
>> you add a condition to Makefile (ifeq ($(ARCH),arm) or something like
>> that) instead of a Kconfig option. I would prefer at least to avoid the
>> unnecessary kconfig option creep.
>
> Uhuh, why should *users* patch the kernel prior building it with
> allmodconfig? We do not want to carry *any* patches with our kernels.

I meant that instead of adding more options we could use the existing
ones in a Makefile, not that you do that in distro kernel only. But
COMPILE_TEST seems to fit the bill quite nicely anyway.

Regards,
--
Alex
