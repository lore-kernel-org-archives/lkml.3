Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbaBZQHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 11:07:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42242 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbaBZQHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 11:07:16 -0500
Message-ID: <530E111A.7050100@zytor.com>
Date: Wed, 26 Feb 2014 08:06:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: davem@davemloft.net, Ingo Molnar <mingo@kernel.org>, tglx@linutronix.de,
        Daniel Borkmann <dborkman@redhat.com>, ffusco@redhat.com,
        tgraf@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86/hash: swap parameters of crc32_u32()
References: <53073986020000780011E2E1@nat28.tlf.novell.com> <530CFC93.8080505@zytor.com> <530CFE3A.2090403@redhat.com> <530CFF25.1080100@zytor.com> <530DC21F020000780011F67D@nat28.tlf.novell.com>
In-Reply-To: <530DC21F020000780011F67D@nat28.tlf.novell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/26/2014 01:29 AM, Jan Beulich wrote:
> 
> or it would be (with parameter order kept and argument order
> swapped)
> 
> static inline u32 crc32_u32(u32 crc, u32 val)
> 		seed = crc32_u32(seed, *p32++);
> 		seed = crc32_u32(seed, tmp);
> 		seed = crc32_u32(seed, *p32++);
> 
> I.e. it is precisely the case that their names and functions disagree
> in the current (unpatched) version.
> 

I guess I think this version seems more logical especially/when this
inline is moved into a global place somewhere.

It's not a big deal, though.

	-hpa

