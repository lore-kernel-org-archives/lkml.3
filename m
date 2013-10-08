Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab3JHTbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:31:44 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38555 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754509Ab3JHTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:31:42 -0400
Date: Tue, 8 Oct 2013 12:31:17 -0700
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Michael Ellerman <michaele@au1.ibm.com>, linux-kernel@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, linuxppc-dev@ozlabs.org,
        Paul Mackerras <paulus@samba.org>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>
Subject: Re: [PATCH 5/9][v5] powerpc: implement is_instr_load_store().
Message-ID: <20131008193117.GA699@us.ibm.com>
References: <1380672911-12812-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1380672911-12812-6-git-send-email-sukadev@linux.vnet.ibm.com>
 <20131003053519.GC17237@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003053519.GC17237@concordia>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100819-0320-0000-0000-00000148A2F0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Ellerman [michael@ellerman.id.au] wrote:
| bool is_load_store(int ext_opcode)
| {
|         upper = ext_opcode >> 5;
|         lower = ext_opcode & 0x1f;
| 
|         /* Short circuit as many misses as we can */
|         if (lower < 3 || lower > 23)
|             return false;

I see some loads/stores like these which are not covered by
the above check. Is it ok to ignore them ?

	lower == 29: ldepx, stdepx, eviddepx, evstddepx

	lower == 31: lwepx, lbepx, lfdepx, stfdepx,

Looking through the opcode maps, I also see these for primary
op code 4:

	evldd, evlddx, evldwx, evldw, evldh, evldhx.

Should we include those also ?

Sukadev

