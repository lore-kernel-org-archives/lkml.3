Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745AbaC3W10 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 18:27:26 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:41141 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaC3W1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 18:27:25 -0400
From: Stewart Smith <stewart@linux.vnet.ibm.com>
To: Greg Kurz <gkurz@linux.vnet.ibm.com>, benh@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, anton@samba.org,
        nfont@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] powerpc/le: enable RTAS events support
In-Reply-To: <20140328073344.26823.32931.stgit@bahia.local>
References: <20140328073344.26823.32931.stgit@bahia.local>
User-Agent: Notmuch/0.16 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-redhat-linux-gnu)
Date: Mon, 31 Mar 2014 09:27:16 +1100
Message-ID: <87vbuv9vaz.fsf@river.i-did-not-set--mail-host-address--so-tickle-me>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14033022-8256-0000-0000-00000C335DBB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Kurz <gkurz@linux.vnet.ibm.com> writes:
>  struct rtas_error_log {
> +#ifdef __BIG_ENDIAN__
> +	/* Byte 0 */
>  	unsigned long version:8;		/* Architectural version */
> +	/* Byte 1 */

I think it would be great if we got rid of the usage of bitfields. As
soon as the mood of the compiler changes, this code is going to break.

