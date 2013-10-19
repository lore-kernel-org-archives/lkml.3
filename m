Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3JSRJZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 13:09:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752120Ab3JSRJY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 13:09:24 -0400
Date: Sat, 19 Oct 2013 19:02:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/13] uprobes: allow ignoring of probe hits
Message-ID: <20131019170214.GA8324@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-3-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381871068-27660-3-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, David Long wrote:
>
> @@ -1732,9 +1732,6 @@ static void handle_swbp(struct pt_regs *regs)
>  		return;
>  	}
>  
> -	/* change it in advance for ->handler() and restart */
> -	instruction_pointer_set(regs, bp_vaddr);
> -

Well, this looks obviously wrong. This SET_IP() has the comment ;)

Note also that with this breaks __skip_sstep() on x86.

Oleg.

