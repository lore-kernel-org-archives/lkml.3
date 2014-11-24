Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaKXKMU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 05:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbaKXKMQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 05:12:16 -0500
Message-ID: <54730475.9040000@redhat.com>
Date: Mon, 24 Nov 2014 11:12:05 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: nick <xerofoify@gmail.com>, gleb@kernel.org
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Another Obsolete Fix me in trace.h?
References: <5472B5B5.5090201@gmail.com>
In-Reply-To: <5472B5B5.5090201@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/11/2014 05:36, nick wrote:
> Greetings Again Gleb and others,
> I am assuming in the code I am pasting below the fix me is obsolete now and I can remove it. :)
> Cheers Nick
> TP_printk("%s (0x%x)",
>                   __print_symbolic(__entry->exception, kvm_trace_sym_exc),
>                    /* FIXME: don't print error_code if not present */
>                   __entry->has_error ? __entry->error_code : 0)
> );
> 

No, it's not obsolete, the idea is to print only

   %s

instead of

   %s (0x%x)

if __entry->has_error is false.  I don't know the trace API well enough
to know if that is possible.

Paolo
