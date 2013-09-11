Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397Ab3IKVX6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:23:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:23383 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757084Ab3IKVX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:23:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,886,1371106800"; 
   d="scan'208";a="401979540"
From: "Dilger, Andreas" <andreas.dilger@intel.com>
To: Christoph Hellwig <hch@infradead.org>, Peng Tao <bergwolf@gmail.com>
CC: Guenter Roeck <linux@roeck-us.net>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Thread-Topic: [PATCH] staging: Disable lustre file system for MIPS, SH, and
 XTENSA
Thread-Index: AQHOrklEd3VMd3m790y9aLBKGonWLpnAOb+AgAALhYCAAAFBAIAABfsAgADkkYD//+2NgA==
Date: Wed, 11 Sep 2013 21:23:54 +0000
Message-ID: <CE56334C.69F30%andreas.dilger@intel.com>
In-Reply-To: <20130911162955.GA1103@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.254.109.190]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <AB336507B7C7324EB58C57460B9F60F1@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/09/11 10:29 AM, "Christoph Hellwig" <hch@infradead.org> wrote:
>Talking about nasty code, the whole linux-curproc.c is highly
>questionable:
>
> - cfs_curproc_groups_nr:
>   	unused and should be removed

This is already removed in the upstream Lustre code, it just hasn't made
it into the kernel yet.

>- cfs_cap_raise/cfs_cap_lower/cfs_cap_raised:
>   	needs to go away, modyules must not change access permissions
>	on behalf of processes

These are only used on the server so that threads running as user UID/GID
can write to recovery log files.  There is likely a different way that
this could be done, it has probably been this way from years ago when we
used the VFS to do file IO on the server and it was doing file permission
checking again.

> - the whole cfs_cap_t handling also needs to go away, passing around
>   capabilities is not a concept the kernel supports for a reason
>
> - current_is_32bit:
>	Code should just use is_compat_task directly.

This was already removed in the upstream Lustre code.

>I've just taken the time to walk through this one file, but it seems
>like most of libcfs is just as bad.

Sure, and that's why Lustre is in drivers/staging and not fs/, and I don't
make any claims to the contrary.  We are slowly cleaning out these macros
(added when we wanted to get Lustre working on MacOS and WinNT), but it
will take some time.  XFS lived with an IRIX shim layer for years, and
still
has a whole vnode abstraction layer that nobody seems to be complaining
about, so I don't think it is unreasonable for us to take some time to
clean
up Lustre.

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


