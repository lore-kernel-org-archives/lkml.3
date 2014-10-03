Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaJCUPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 16:15:38 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:39192 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbaJCUPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 16:15:32 -0400
Message-ID: <542F03CF.8010900@c-s.fr>
Date: Fri, 03 Oct 2014 22:15:11 +0200
From: christophe leroy <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Marcelo Tosatti <marcelo@kvack.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-spi@vger.kernel.org,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>,
        scottwood@freescale.com
Subject: Re: [PATCH 2/2] spi: fsl-spi: Allow dynamic allocation of CPM1 parameter
 RAM
References: <20141003125609.5BEA11AB276@localhost.localdomain> <20141003144420.GC24441@sirena.org.uk>
In-Reply-To: <20141003144420.GC24441@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Antivirus: avast! (VPS 141003-0, 03/10/2014), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 03/10/2014 16:44, Mark Brown a écrit :
> On Fri, Oct 03, 2014 at 02:56:09PM +0200, Christophe Leroy wrote:
>
>> +config CPM1_RELOCSPI
>> +	bool "Dynamic SPI relocation"
>> +	default n
>> +	help
>> +	  On recent MPC8xx (at least MPC866 and MPC885) SPI can be relocated
>> +	  without micropatch. This activates relocation to a dynamically
>> +	  allocated area in the CPM Dual port RAM.
>> +	  When combined with SPI relocation patch (for older MPC8xx) it avoids
>> +	  the "loss" of additional Dual port RAM space just above the patch,
>> +	  which might be needed for example when using the CPM QMC.
> Something like this shouldn't be a compile time option.  Either it
> should be unconditional or it should be triggered in some system
> specific manner (from DT, from knowing about other users or similar).
Can't be unconditional as older versions of mpc8xx (eg MPC860) don't 
support relocation without a micropatch.
I have therefore submitted a v2 based on a DTS compatible property.

---
Ce courrier électronique ne contient aucun virus ou logiciel malveillant parce que la protection avast! Antivirus est active.
http://www.avast.com

