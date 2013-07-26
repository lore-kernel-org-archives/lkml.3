Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3GZNYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 09:24:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758868Ab3GZNYL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 09:24:11 -0400
Date: Fri, 26 Jul 2013 09:23:35 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jingbai Ma <jingbai.ma@hp.com>
Cc: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kumagai-atsushi@mxc.nes.nec.co.jp" 
	<kumagai-atsushi@mxc.nes.nec.co.jp>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>, cpw@sgi.com,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "Croxon, Nigel" <nigel.croxon@hp.com>,
        "Wang, Jin (Steven)" <jin.wang@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: makedumpfile 1.5.4 + kernel 3.11-rc2+ 4TB tests
Message-ID: <20130726132335.GA27529@redhat.com>
References: <51F260AF.7010409@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F260AF.7010409@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 07:42:39PM +0800, Jingbai Ma wrote:
> Hi,
> 
> I have run some tests with makedumpfile 1.5.4 and upstream kernel
> 3.11-rc2+ on a machine with 4TB memory, here is testing results:
> 
> Test environment:
> Machine: HP ProLiant DL980 G7 with 4TB RAM.
> CPU: Intel(R) Xeon(R) CPU E7- 2860  @ 2.27GHz (8 sockets, 10 cores)
> (Only 1 CPU was enabled the 2nd kernel)
> Kernel: 3.11.0-rc2+ (at patch b3a3a9c441e2c8f6b6760de9331023a7906a4ac6)
> crashkernel=384MB
> vmcore size: 4.0TB
> Dump file size: 15GB
> All measured time from debug message of makedumpfile.
> As a comparison, I also have tested makedumpfile 1.5.3.
> 
> (all time in seconds)
>                      Excluding pages   Copy data   Total
> makedumpfile 1.5.3          468         1182       1650
> makedumpfile 1.5.4           93          518        611
> 
> 
> So it seems there is a great performance improvement by the mmap mechanism.

[CC Andrew].

Thanks Jingbai for testing results. Good to see that vmcore mmap() patches
are helping.

Thanks
Vivek
