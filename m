Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654AbaF0Llh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:41:37 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:37810 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbaF0Llg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:41:36 -0400
Message-ID: <53AD586A.40900@redhat.com>
Date: Fri, 27 Jun 2014 13:41:30 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86-ml <x86@kernel.org>,
        kvm@vger.kernel.org, =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Subject: Re: __schedule #DF splat
References: <20140625153227.GA13845@pd.tnic> <20140625202650.GC13845@pd.tnic> <20140627101831.GB23153@pd.tnic>
In-Reply-To: <20140627101831.GB23153@pd.tnic>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 27/06/2014 12:18, Borislav Petkov ha scritto:
> Joerg says I should bisect but I'm busy with other stuff. If people are
> interested in chasing this further, I could free up some time to do
> so...

Please first try "-M pc-1.7" on the 2.0 QEMU.  If it fails, please do 
bisect it.  A QEMU bisection between one release only usually takes only 
half an hour or so for me.

I use

../configure --target-list=x86_64-softmmu && make distclean &&
../configure --target-list=x86_64-softmmu &&
make -j8 subdir-x86_64-softmmu

Until it's below 50 commits.  After that point just "make -j8 
subdir-x86_64-softmmu" should do.  This ensures that build system 
changes do not bite you as you move back and forth in time.

Thanks!

Paolo
