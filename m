Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbaGISlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:41:23 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64306 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaGISlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:41:22 -0400
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x290/0x2fa()
Date: Wed, 09 Jul 2014 20:41:17 +0200
Message-ID: <1502740.TF1NxA0qsa@calvin>
User-Agent: KMail/4.13.2 (Linux/3.14.0-rc1+; KDE/4.13.2; x86_64; ; )
In-Reply-To: <20140707204747.GA24934@kroah.com>
References: <CADpTngUm7d88RJS9OV=64t6QrJU4r3M_Z8eV1QYWPeeB5SX5-w@mail.gmail.com> <20140707204747.GA24934@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In data lunedì 7 luglio 2014 13:47:47, Greg Kroah-Hartman ha scritto:
> On Mon, Jul 07, 2014 at 10:32:56PM +0200, Fabio Coatti wrote:
> > I'm seeing this message in latest kernels (this is from 3.15.4, but I have
> > same
> > message starting from 3.15.0, IIRC):
> So 3.14.0 didn't show this?
> 
> If so, can you run 'git bisect' between those two kernel versions to try
> to track down the issue?
> 
> thanks,
> 
> greg k-h
ok, I tried to bisect as suggested and got the commit reported below. However 
I'm not really sure to have got the right one, as one kernel refused to 
compile during the last steps. However I post here the result, maybe they can 
be useful.
Tomorrow I can retry the whole process again starting from different commits.


b9e1ab6d4c0582cad97699285a6b3cf992251b00 is the first bad commit
commit b9e1ab6d4c0582cad97699285a6b3cf992251b00
Author: Stephane Eranian <eranian@google.com>
Date:   Tue Feb 11 16:20:12 2014 +0100

    perf/x86/uncore: add SNB/IVB/HSW client uncore memory controller support
    
    This patch adds a new uncore PMU for Intel SNB/IVB/HSW client
    CPUs. It adds the Integrated Memory Controller (IMC) PMU. This
    new PMU provides a set of events to measure memory bandwidth utilization.
    
    The IMC on those processor is PCI-space based. This patch
    exposes a new uncore PMU on those processor: uncore_imc
    
    Two new events are defined:
      - name: data_reads
      - code: 0x1
      - unit: 64 bytes
      - number of full cacheline read requests to the IMC
    
      - name: data_writes
      - code: 0x2
      - unit: 64 bytes
      - number of full cacheline write requests to the IMC
    
    Documentation available at:
    http://software.intel.com/en-us/articles/monitoring-integrated-memory-controller-requests-in-the-2nd-3rd-and-4th-generation-intel
    
    Cc: mingo@elte.hu
    Cc: acme@redhat.com
    Cc: ak@linux.intel.com
    Cc: zheng.z.yan@intel.com
    Cc: peterz@infradead.org
    Signed-off-by: Stephane Eranian <eranian@google.com>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>                                                                                                                                        
    Link: http://lkml.kernel.org/r/1392132015-14521-7-git-send-email-eranian@google.com                                                                                                         
    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>                                                                                                                                         
                                                                                                                                                                                                
:040000 040000 2d628022cbc4b8969a2ec311082053510cf6eed5 
79b2a1cc3ed29e4820a5ae4221b4cf603c138887 M      arch   


-- 
Fabio
