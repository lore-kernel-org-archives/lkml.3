Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641AbaBXNRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:17:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34639 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752301AbaBXNRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:17:04 -0500
Message-ID: <530B462E.9070009@zytor.com>
Date: Mon, 24 Feb 2014 05:16:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Daniel Borkmann <borkmann@iogearbox.net>
CC: Jan Beulich <JBeulich@suse.com>, Daniel Borkmann <dborkman@redhat.com>,
        davem@davemloft.net, mingo@elte.hu, tglx@linutronix.de,
        ffusco@redhat.com, tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com> <5308938A.8070506@redhat.com> <530B0AF2020000780011E97B@nat28.tlf.novell.com> <530B1D60.8010602@redhat.com> <530B32A4020000780011EACB@nat28.tlf.novell.com> <530B3102.4050102@redhat.com> <530B3BDB.3010908@zytor.com> <530B4C0C020000780011EC0D@nat28.tlf.novell.com> <530B4058.80705@zytor.com> <530B429C.2090507@zytor.com> <530B449C.8030205@iogearbox.net>
In-Reply-To: <530B449C.8030205@iogearbox.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a totally different note, it would probably be a good idea to use 
intrinsics more in the kernel where possible.  Intrinsics do allow the 
compiler to generate better scheduling.

The trick of course is that we'd want to have machinery that can fall 
back to inline assembly if the compiler doesn't support the intrinsics, 
and perhaps even to .bytes if needed.  This pretty much involves a bunch 
of compiler and assembler-probing machinery and then wrapping things in 
neat little inline functions.

	-hpa

