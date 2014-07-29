Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbaG2Wys (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 18:54:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300AbaG2Wyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 18:54:47 -0400
Message-ID: <53D82623.4080903@redhat.com>
Date: Tue, 29 Jul 2014 18:54:27 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <53D82118.6090202@redhat.com> <20140729223603.GC17241@pd.tnic>
In-Reply-To: <20140729223603.GC17241@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/29/2014 06:36 PM, Borislav Petkov wrote:
> On Tue, Jul 29, 2014 at 06:32:56PM -0400, Prarit Bhargava wrote:
>> and it was best to keep the code simple with a KiB.
> 
> You're missing the point - the output doesn't get simple with KiB. Read
> the example I just gave you!
> 
> (13893632kiB) is actively *not* helping when one looks at it!

I did get your point and I'm (politely) disagreeing with it.  Your case ONLY
works if the number is _exactly_ 13GB.  What if it is 13.5?  Then we're still
rounding off and reporting 14GB.  Which, if this code is meant for debug, makes
no sense to me.  Why round it off?

P.

> 
