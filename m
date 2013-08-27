Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab3H0G7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 02:59:09 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:37196 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab3H0G7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 02:59:08 -0400
Date: Tue, 27 Aug 2013 08:58:53 +0200
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-arch@vger.kernel.org,
        Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [guv v2 25/31] avr32: Replace __get_cpu_var uses
Message-ID: <20130827065853.GA2153@samfundet.no>
References: <20130826204351.725357339@linux.com>
 <00000140bc69acd0-a726b027-118a-48bd-a832-a6454a9dfe04-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00000140bc69acd0-a726b027-118a-48bd-a832-a6454a9dfe04-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Mon 26 Aug 2013 20:56:16 +0000 or thereabout, Christoph Lameter wrote:

<snipp reasoning>

> Index: linux/arch/avr32/kernel/kprobes.c
> ===================================================================
> --- linux.orig/arch/avr32/kernel/kprobes.c	2013-08-26 13:25:18.000000000 -0500
> +++ linux/arch/avr32/kernel/kprobes.c	2013-08-26 13:27:09.758485808 -0500
> @@ -104,7 +104,7 @@ static void __kprobes resume_execution(s
>  
>  static void __kprobes set_current_kprobe(struct kprobe *p)
>  {
> -	__get_cpu_var(current_kprobe) = p;
> +	__this_cpu_write(current_kprobe, p);
>  }
>  
>  static int __kprobes kprobe_handler(struct pt_regs *regs)

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

-- 
mvh
Hans-Christian Egtvedt
