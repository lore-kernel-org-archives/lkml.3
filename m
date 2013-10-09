Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab3JIBDV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 21:03:21 -0400
Received: from ozlabs.org ([203.10.76.45]:60302 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751896Ab3JIBDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 21:03:20 -0400
Message-ID: <1381280599.15322.1.camel@concordia>
Subject: Re: [PATCH 5/9][v5] powerpc: implement is_instr_load_store().
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Date: Wed, 09 Oct 2013 12:03:19 +1100
In-Reply-To: <20131008193117.GA699@us.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
	 <1380672911-12812-6-git-send-email-sukadev@linux.vnet.ibm.com>
	 <20131003053519.GC17237@concordia> <20131008193117.GA699@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-08 at 12:31 -0700, Sukadev Bhattiprolu wrote:
> Michael Ellerman [michael@ellerman.id.au] wrote:
> | bool is_load_store(int ext_opcode)
> | {
> |         upper = ext_opcode >> 5;
> |         lower = ext_opcode & 0x1f;
> | 
> |         /* Short circuit as many misses as we can */
> |         if (lower < 3 || lower > 23)
> |             return false;
> 
> I see some loads/stores like these which are not covered by
> the above check. Is it ok to ignore them ?
> 
> 	lower == 29: ldepx, stdepx, eviddepx, evstddepx
> 
> 	lower == 31: lwepx, lbepx, lfdepx, stfdepx,

Those are the external process ID instructions, which I've never heard
of anyone using, I think we can ignore them.

> Looking through the opcode maps, I also see these for primary
> op code 4:
> 
> 	evldd, evlddx, evldwx, evldw, evldh, evldhx.
> 
> Should we include those also ?

Yes I think so. I didn't check any of the other opcodes for you.

cheers

