Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755044Ab3AaVm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 16:42:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44333 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752632Ab3AaVm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 16:42:57 -0500
Message-ID: <510AE4F6.1050407@zytor.com>
Date: Thu, 31 Jan 2013 13:41:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: "K. Y. Srinivasan" <kys@microsoft.com>, olaf@aepfle.de, bp@alien8.de,
        apw@canonical.com, x86@kernel.org, tglx@linutronix.de,
        devel@linuxdriverproject.org, gregkh@linuxfoundation.org,
        jasowang@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
References: <1359507077-26050-1-git-send-email-kys@microsoft.com> <1359507108-26091-1-git-send-email-kys@microsoft.com> <1359507108-26091-2-git-send-email-kys@microsoft.com> <5108ED9702000078000BAA08@nat28.tlf.novell.com>
In-Reply-To: <5108ED9702000078000BAA08@nat28.tlf.novell.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2013 12:53 AM, Jan Beulich wrote:
> 
> I'm not convinced that's the right approach - any hypervisor
> could do similar emulation, and hence you either want to make
> sure you run on Hyper-V (by excluding all others), or you
> tolerate using the emulation (which may require syncing up with
> the other guest implementations so that shared resources don't
> get used by two parties).
> 
> I also wonder whether using the Hyper-V emulation (where
> useful, there might not be anything right now, but this may
> change going forward) when no Xen support is configured
> wouldn't be better than not using anything...
> 

I'm confused about "the right approach" here is.  As far as I
understand, this only can affect a Xen guest where HyperV guest support
is enabled but not Xen support, and only because Xen emulates HyperV but
does so incorrectly.

This is a Xen bug, and as such it makes sense to reject Xen
specifically.  If another hypervisor emulates HyperV and does so
correctly there seems to be no reason to reject it.

	-hpa


