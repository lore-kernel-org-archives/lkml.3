Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab3DYOTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:19:20 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:42904 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932519Ab3DYOTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:19:01 -0400
Date: Thu, 25 Apr 2013 22:18:57 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@freescale.com>
Cc: Vakul Garg <vakul@freescale.com>, linux-crypto@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Kim Phillips <kim.phillips@freescale.com>,
        Bharat Bhushan <bharat.bhushan@freescale.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv1] crypto: caam - fix job ring cleanup code
Message-ID: <20130425141856.GC29501@gondor.apana.org.au>
References: <1365999951-20635-1-git-send-email-vakul@freescale.com>
 <516BC127.3080708@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <516BC127.3080708@freescale.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:58:15AM +0300, Horia Geantă wrote:
> On 4/15/2013 7:25 AM, Vakul Garg wrote:
> >The job ring init function creates a platform device for each job ring.
> >While the job ring is shutdown, e.g. while caam module removal, its
> >platform device was not being removed. This leads to failure while
> >reinsertion and then removal of caam module second time.
> >
> >The following kernel crash dump appears when caam module is reinserted
> >and then removed again. This patch fixes it.
> >
> >root@p4080ds:~# rmmod caam.ko
> >Unable to handle kernel paging request for data at address 0x00000008
> >Faulting instruction address: 0xf94aca18
> >Oops: Kernel access of bad area, sig: 11 [#1]
> >SMP NR_CPUS=8 P4080 DS
> >Modules linked in: caam(-) qoriq_dbg(O) [last unloaded: caam]
> >NIP: f94aca18 LR: f94aca18 CTR: c029f950
> >REGS: eac47d60 TRAP: 0300   Tainted: G           O  (3.8.4-rt2)
> >MSR: 00029002 <CE,EE,ME>  CR: 22022484  XER: 20000000
> >DEAR: 00000008, ESR: 00000000
> >TASK = e49dfaf0[2110] 'rmmod' THREAD: eac46000 CPU: 1
> >GPR00: f94ad3f4 eac47e10 e49dfaf0 00000000 00000005 ea2ac210 ffffffff 00000000
> >GPR08: c286de68 e4977ce0 c029b1c0 00000001 c029f950 10029738 00000000 100e0000
> >GPR16: 00000000 10023d00 1000cbdc 1000cb8c 1000cbb8 00000000 c07dfecc 00000000
> >GPR24: c07e0000 00000000 1000cbd8 f94e0000 ffffffff 00000000 ea53cd40 00000000
> >NIP [f94aca18] caam_reset_hw_jr+0x18/0x1c0 [caam]
> >LR [f94aca18] caam_reset_hw_jr+0x18/0x1c0 [caam]
> >Call Trace:
> >[eac47e10] [eac47e30] 0xeac47e30 (unreliable)
> >[eac47e20] [f94ad3f4] caam_jr_shutdown+0x34/0x220 [caam]
> >[eac47e60] [f94ac0e4] caam_remove+0x54/0xb0 [caam]
> >[eac47e80] [c029fb38] __device_release_driver+0x68/0x120
> >[eac47e90] [c02a05c8] driver_detach+0xd8/0xe0
> >[eac47eb0] [c029f8e0] bus_remove_driver+0xa0/0x110
> >[eac47ed0] [c00768e4] sys_delete_module+0x144/0x270
> >[eac47f40] [c000e2f0] ret_from_syscall+0x0/0x3c
> >
> >
> >Signed-off-by: Vakul Garg <vakul@freescale.com>
> >Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> >---
> 
> Reviewed-by: Horia Geanta <horia.geanta@freescale.com>

Patch applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
