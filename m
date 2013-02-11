Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474Ab3BKRtc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 12:49:32 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:36678 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758096Ab3BKRtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 12:49:31 -0500
Message-ID: <51192B39.9060501@linux.vnet.ibm.com>
Date: Mon, 11 Feb 2013 09:32:41 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH 1/2] add helper for highmem checks
References: <20130208202813.62965F25@kernel.stglabs.ibm.com> <20130209094121.GB17728@pd.tnic> <20130209104751.GC17728@pd.tnic>
In-Reply-To: <20130209104751.GC17728@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021117-7182-0000-0000-0000051F4383
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2013 02:47 AM, Borislav Petkov wrote:
> On Sat, Feb 09, 2013 at 10:41:21AM +0100, Borislav Petkov wrote:
> With this change, they definitely fix something because I even get X on
> the box started. Previously, it would spit out the warning and wouldn't
> start X with the login window. And my suspicion is that wdm (WINGs
> display manager) I'm using, does /dev/mem accesses when it starts and it
> obviously failed. Now not so much :-)

That's crazy.  Didn't expect that at all.

I guess X is happier getting an error than getting random pages back.
I'm working on a set of patches now that should get it _working_ instead
of just returning an error.

