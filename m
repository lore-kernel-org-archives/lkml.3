Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030770AbaDJMtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 08:49:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030551AbaDJMtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 08:49:47 -0400
Message-ID: <53469358.4060502@redhat.com>
Date: Thu, 10 Apr 2014 14:49:28 +0200
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>, Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 6/6] uprobes/x86: Emulate rip-relative conditional
 "near" jmp's
References: <20140409194442.GA6245@redhat.com>
In-Reply-To: <20140409194442.GA6245@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 09:44 PM, Oleg Nesterov wrote:
> +	case 0x0f:
> +		if (insn->opcode.nbytes != 2)
> +			return -ENOSYS;
> +		/*
> +		 * If it is a "near" conditional jmp, OPCODE2() - 0x10 matches
> +		 * OPCODE1() of the "short" jmp which checks the same condition.
> +		 */

I propose:

/*
 * Near conditional jump opcodes: 0f 80..8f
 * Short conditional jump opcodes: 70..7f
 * Convert OPCODE2() to corresponding short jump opcode:
 */

> +		opc1 = OPCODE2(insn) - 0x10;
>  	default:

