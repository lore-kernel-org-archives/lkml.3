Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964958Ab3GLW2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 18:28:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41749 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3GLW2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 18:28:32 -0400
Message-ID: <51E082F6.4030305@zytor.com>
Date: Fri, 12 Jul 2013 15:28:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>, Fenghua Yu <fenghua.yu@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Seiji Aguchi <seiji.aguchi@hds.com>,
        PaX Team <pageexec@freemail.hu>
Subject: Re: [PATCH] x86: make sure IDT is page aligned
References: <20130712183014.GA20551@www.outflux.net>
In-Reply-To: <20130712183014.GA20551@www.outflux.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2013 11:30 AM, Kees Cook wrote:
>  
> -	.word 0				# 32-bit align idt_desc.address
> +	.word PAGE_SIZE			# page align idt_desc.address
> 

... and this is totally confused.  This didn't change alignment one
iota, it only put the value 4096 into the padding.

	-hpa

