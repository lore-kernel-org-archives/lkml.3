Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab3H2VtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 17:49:08 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:45110 "HELO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756157Ab3H2VtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 17:49:07 -0400
X-Greylist: delayed 382 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Aug 2013 17:49:06 EDT
MIME-Version: 1.0
In-Reply-To: <CAMuHMdVG9FmZNayrf7HMz4kC4X5QELeXUFjjzpAM80ND_QOm8A@mail.gmail.com>
References: <CAMuHMdVG9FmZNayrf7HMz4kC4X5QELeXUFjjzpAM80ND_QOm8A@mail.gmail.com>
From: Jesse Gross <jesse@nicira.com>
Date: Thu, 29 Aug 2013 14:42:22 -0700
Message-ID: <CAEP_g=-XvRiHPzSAp2rgC9Hxdd+pGEHvSTEJ1A1SkWnk1-6xZA@mail.gmail.com>
Subject: Re: [-next] openvswitch BUILD_BUG_ON failed
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andy Zhou <azhou@nicira.com>, "dev@openvswitch.org" <dev@openvswitch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 2:21 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> However, I have some doubts about other alignment "enforcements":
>
> "__aligned(__alignof__(long))" makes the whole struct aligned to the
> alignment rule for "long":
>    1. This is only 2 bytes on m68k, i.e. != sizeof(long).
>    2. This is 4 bytes on many 32-bit platforms, which may be less than the
>       default alignment for "__be64" (cfr. some members of struct
>       ovs_key_ipv4_tunnel), so this may make those 64-bit members unaligned.

Do any of those 32-bit architectures actually care about alignment of
64 bit values? On 32-bit x86, a long is 32 bits but the alignment
requirement of __be64 is also 32 bit.
