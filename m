Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab3JPI2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 04:28:05 -0400
Received: from mx0.aculab.com ([213.249.233.131]:49020 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755174Ab3JPI2B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 04:28:01 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
Date: Wed, 16 Oct 2013 09:25:35 +0100
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B738E@saturn3.aculab.com>
In-Reply-To: <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 02/10][v6] powerpc/Power7: detect load/store instructions
Thread-Index: Ac7KFHEwWxI4h8zlTqiniITa4wx3vgANH7AQ
References: <1381889202-16826-1-git-send-email-sukadev@linux.vnet.ibm.com> <1381889202-16826-3-git-send-email-sukadev@linux.vnet.ibm.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Sukadev Bhattiprolu" <sukadev@linux.vnet.ibm.com>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>
Cc: "Michael Ellerman" <michaele@au1.ibm.com>, <linux-kernel@vger.kernel.org>,
        "Stephane Eranian" <eranian@google.com>, <linuxppc-dev@ozlabs.org>,
        "Paul Mackerras" <paulus@samba.org>,
        "Anshuman Khandual" <khandual@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Implement instr_is_load_store_2_06() to detect whether a given instruction
> is one of the fixed-point or floating-point load/store instructions in the
> POWER Instruction Set Architecture v2.06.
...
> +int instr_is_load_store_2_06(const unsigned int *instr)
> +{
> +	unsigned int op, upper, lower;
> +
> +	op = instr_opcode(*instr);
> +
> +	if ((op >= 32 && op <= 58) || (op == 61 || op == 62))
> +		return true;
> +
> +	if (op != 31)
> +		return false;
> +
> +	upper = op >> 5;
> +	lower = op & 0x1f;
> +
> +	/* Short circuit as many misses as we can */
> +	if (lower < 3 || lower > 23)
> +		return false;
> +
> +	if (lower == 3) {
> +		if (upper >= 16)
> +			return true;
> +
> +		return false;
> +	}
> +
> +	if (lower == 7 || lower == 12)
> +		return true;
> +
> +	if (lower >= 20) /* && lower <= 23 (implicit) */
> +		return true;
> +
> +	return false;
> +}

I can't help feeling the code could do with some comments about
which actual instructions are selected where.

	David



