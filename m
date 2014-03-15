Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754478AbaCOO0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2014 10:26:51 -0400
Received: from mail.skyhub.de ([78.46.96.112]:44144 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753707AbaCOO0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2014 10:26:50 -0400
Date: Sat, 15 Mar 2014 15:26:25 +0100
From: Borislav Petkov <bp@alien8.de>
To: Linn Crosetto <linn@hp.com>
Cc: Matt Fleming <matt@console-pimps.org>, Dave Young <dyoung@redhat.com>,
        WANG Chao <chaowang@redhat.com>, kexec@lists.infradead.org,
        horms@verge.net.au, ebiederm@xmission.com, hpa@zytor.com,
        trenn@suse.de, vgoyal@redhat.com, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/4] x86: Pass memory range via E820 for kdump
Message-ID: <20140315142625.GA8735@nazgul.tnic>
References: <1394464149-30384-1-git-send-email-chaowang@redhat.com>
 <1394464149-30384-5-git-send-email-chaowang@redhat.com>
 <20140313222428.GW7672@oranje.fc.hp.com>
 <20140314024726.GA2245@dhcp-16-126.nay.redhat.com>
 <20140314082615.GE5834@console-pimps.org>
 <20140314202706.GX7672@oranje.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140314202706.GX7672@oranje.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 02:27:06PM -0600, Linn Crosetto wrote:
> Since this testing was done on a prototype, I will send you the log in
> a separate email. I tried efi.git/next (with the addition of 4ce7a86),
> and hit the same panic.

Well, if the stack trace is the same:

>  ? __unmap_pmd_range+0x77/0x190
>  unmap_pmd_range+0xcf/0x1c0
>  populate_pgd+0x16d/0x250
>  __cpa_process_fault+0x15/0xb0
...

it looks like populate_pgd() fails and unmaps the whole range. You could
add some debug printks to find out exactly why populate_pgd() fails.
Also, please try to catch full dmesg and the whole oops.

Btw, Matt, your whole efi/next stuff is already in tip, right? Because
if so, Linn could simply test latest tip/master.

Thanks.
