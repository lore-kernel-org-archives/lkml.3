Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933159Ab3LDUVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:21:14 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:35385 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3LDUVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:21:10 -0500
Date: Wed, 4 Dec 2013 13:21:04 -0700
From: Jerry.Hoemann@hp.com
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@alien8.de>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jingbai Ma <jingbai.ma@hp.com>
Subject: Re: [PATCH v9] x86, apic, kexec, Documentation: Add disable_cpu_apic
 kernel parameter
Message-ID: <20131204202104.GA6348@anatevka.fc.hp.com>
Reply-To: Jerry.Hoemann@hp.com
References: <529D34AA.1000809@jp.fujitsu.com>
 <20131203152536.GE4251@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131203152536.GE4251@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 10:25:36AM -0500, Vivek Goyal wrote:
> 
> Hi Hatayama, 
> 
> We are almost there. A minor nit. Why have we specified KEXEC here. This
> parameter disabled_cpu_apicid does not seem to dependon CONFIG_KEXEC?
> 
> Jerry, this patch looks good to me. Does it work on your system?
> 
> Thanks
> Vivek


Vivek,  Hatayama,

I've back ported v9 of this patch to 2.6.32 and 3.0.80 based kernels to
test with existing distros.

I've tested on our smaller prototype server specifying nr_cpus=8/maxcpus=8
to the capture kernel.  One hundred iterations (echo c > /proc/sysrq-trigger)
varying target cpu and system load to each kernel.

The 2.6.32 based distro kernel showed the < 5% soft lockup
(still unresolved) during boot of capture kernel.  This is
something i've seen on all versions of the patch that i've tested.

The 3.0.80 based distro kernel has had zero failures.

I have not had a chance to test upstream kernels or on
our larger prototype configuration.

We still plan to test on our larger prototype.  Testing of
prior versions of the patch on the larger systems didn't show
problems w/ this functionality and I don't anticipate we'll
find anything this time either.

I am okay with this patch being accepted upstream and working
the intermittent 2.6.32 failures separately.


Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann@hp.com
----------------------------------------------------------------------------

