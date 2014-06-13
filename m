Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088AbaFMPgZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 11:36:25 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58580 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbaFMPgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 11:36:23 -0400
Date: Fri, 13 Jun 2014 17:36:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, Dave Young <dyoung@redhat.com>,
        mjg59@srcf.ucam.org, bhe@redhat.com, jkosina@suse.cz, greg@kroah.com,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 07/13] kexec: Implementation of new syscall
 kexec_file_load
Message-ID: <20140613153620.GG4751@pd.tnic>
References: <1401800822-27425-1-git-send-email-vgoyal@redhat.com>
 <1401800822-27425-8-git-send-email-vgoyal@redhat.com>
 <20140606065605.GE2785@dhcp-17-89.nay.redhat.com>
 <20140606181859.GK1526@redhat.com>
 <20140609021122.GB1924@darkstar.nay.redhat.com>
 <20140609053538.GA2874@dhcp-17-89.nay.redhat.com>
 <20140609154137.GD22049@redhat.com>
 <20140613075011.GA4751@pd.tnic>
 <20140613124609.GC5871@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140613124609.GC5871@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2014 at 08:46:09AM -0400, Vivek Goyal wrote:
> If not, then we really can't do anything about it. A large memory
> allocation will fail and user will get error.

Of course we can! You can't trust userspace and you need to check the
values it gives you through the syscall.

And you need a sane default. The fact that I even have to state this
explicitly...!

So what if userspace gives a maximum value for which allocation
succeeds? Does that mean that the kernel should blindly comply and
allocate? Of course not! That would be dumb.

> I disagree here. What if new kernel supports (2 * COMMAND_LINE_SIZE)
> length command line. We don't want to truncate command line to smaller
> size because running kernel does not support that long a command line.

Do you have a sensible use case where 2048 cmdline size (on x86) won't
be enough and you really need it larger?

And even if this is a problem - which I seriously doubt - it would be
problem with the 1st kernel too, not only with the kexec-ed one.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
