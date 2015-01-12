Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbbALXrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 18:47:20 -0500
Received: from mga11.intel.com ([192.55.52.93]:44978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbbALXrU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 18:47:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="511219511"
Message-ID: <54B45D04.2030309@linux.intel.com>
Date: Mon, 12 Jan 2015 15:47:16 -0800
From: Dave Hansen <dave.hansen@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 3.19 v2 2/3] x86, mpx: Short-circuit the instruction decoder
 for unexpected opcodes
References: <cover.1421103159.git.luto@amacapital.net> <6cb492e6037780a61b973cc9e40050d43452ed63.1421103159.git.luto@amacapital.net>
In-Reply-To: <6cb492e6037780a61b973cc9e40050d43452ed63.1421103159.git.luto@amacapital.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Couple of typos...

On 01/12/2015 03:04 PM, Andy Lutomirski wrote:
> +	/*
> +	 * We only _really_ need to decode bndcl/bndcn/bndcu
> +	 * Error out on anything else.  Check this before decoding the
> +	 * instruction to reduce our exposure to intentionally bad code
> +	 * to some extent.  Note that this shortcut cat incorrectly return

"...can incorrectly return"

> +	 * -EINVAL instead of -EFAULT under some circumstances.  This
> +	 * discrepency has no effect.
> +	 */

	^^ discrepancy


> +	if (nr_copied < 2)
> +		goto bad_opcode;
> +	if (buf[0] != 0x0f)
> +		goto bad_opcode;
> +	if (buf[1] != 0x1a && buf[1] != 0x1b)
> +		goto bad_opcode;
...
> -	/*
> -	 * We only _really_ need to decode bndcl/bndcn/bndcu
> -	 * Error out on anything else.
> -	 */
> -	if (insn->opcode.bytes[0] != 0x0f)
> -		goto bad_opcode;
> -	if ((insn->opcode.bytes[1] != 0x1a) &&
> -	    (insn->opcode.bytes[1] != 0x1b))
> -		goto bad_opcode;

Otherwise, this looks OK to me.  Have you tested this at all?  I know
you don't have any MPX hardware, but you can still hack something in to
point the instruction decoder at an MPX binary.
