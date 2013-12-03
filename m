Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3LCJVI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 04:21:08 -0500
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:64740 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab3LCJVE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 04:21:04 -0500
X-IMSS-HAND-OFF-DIRECTIVE: 10.4.98.62:25
From: "Altunbas Sabri (DC-IA/EAH2)" <sabri.altunbas@boschrexroth.de>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Altunbas Sabri (DC-IA/EAH2)" <sabri.altunbas@boschrexroth.de>
Date: Tue, 3 Dec 2013 10:20:09 +0100
Subject: sh7785: enable_mmu crashes
Thread-Topic: sh7785: enable_mmu crashes
Thread-Index: Ac7wCNy/qeNGM6BrT7qKcTuLme0GJw==
Message-ID: <EADA2943BAC14C4AB625A3550A3BE980096E4A2567@SI-MBX04.de.bosch.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-MML: disable
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I port linux-3.12.1 on my board with sh7785lcr. It crashes at the following point.
 
Can anybody give me please some hints. 

The crash is at that point where mmu is initialised

void __init setup_arch(char **cmdline_p)
{
	enable_mmu();
..
..
}


Befor step

/* Enable MMU */                                                               
__raw_writel(MMU_CONTROL_INIT, MMUCR);                                         
                                 mov.w     @(0x80594E10,pc),r2                 
                                 mov.l     @(0x80594E20,pc),r1                 
                                mov.l r2,@r1                               < ------ breakpoint
ctrl_barrier();                                                                
                                 mov.l     @(0x80594E24,pc),r1                 
                                 icbi      @r1                                 
                                                                               
if (asid_cache(cpu) == NO_CONTEXT)                                             
                                 mov.w     @(0x80594E12,pc),r2                 
                                 mov.l     @(0x80594E28,pc),r3                 
                                 mul.l     r2,r0          ; r2,cpu             
                                 sts       macl,r1                             
                                 add       r3,r1                               


After step

unsigned int cpu = smp_processor_id();                                
                                 shll      r4             ; cmdline_p 
                                 shll      r1                         
                                 shll      r4             ; cmdline_p 
                                                                      
/* Enable MMU */                                                      
__raw_writel(MMU_CONTROL_INIT, MMUCR);                                
                                 shll      r1                         
                                 shll      r4                         
                                 shll      r1                         
ctrl_barrier();                                                       
                                 shll      r4                         
                                 shll      r1                         
                                                                      
if (asid_cache(cpu) == NO_CONTEXT)                                    
                                 shll      r4                         
                                 shll      r1                         
                                 shll      r4                         
                                 shll      r1                         
                                 shll      r4                         
                                 shll      r1
                         
Best regards 
S.Altunbas


