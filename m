Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3FXUIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 16:08:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60991 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab3FXUIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 16:08:38 -0400
Message-ID: <51C8A728.8010409@zytor.com>
Date: Mon, 24 Jun 2013 13:08:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Nathan Zimmer <nzimmer@sgi.com>, holt@sgi.com, travis@sgi.com,
        rob@landley.net, tglx@linutronix.de, mingo@redhat.com,
        yinghai@kernel.org, akpm@linux-foundation.org,
        gregkh@linuxfoundation.org, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC 2/2] x86_64, mm: Reinsert the absent memory
References: <1371831934-156971-1-git-send-email-nzimmer@sgi.com> <1371831934-156971-3-git-send-email-nzimmer@sgi.com> <20130623092840.GB13445@gmail.com> <20130623093250.GA13776@gmail.com> <51C88400.7090907@zytor.com> <20130624193959.GB4065@gmail.com>
In-Reply-To: <20130624193959.GB4065@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2013 12:39 PM, Ingo Molnar wrote:
> 
> That might be a bit too granular: if we hit such an uninitialized block of 
> memory we'd have to process 262,144 pages - potentially from an IRQ 
> handler that does GFP_ATOMIC... or other latency critical code.
> 
> With 2MB we'd have to on-demand initialize 512 pages, which shouldn't show 
> up during normal use.
> 

No... you split the gigabyte page into 511 2M pages and 512 4K pages.

	-hpa


