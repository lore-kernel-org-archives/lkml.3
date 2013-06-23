Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970Ab3FWCKl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jun 2013 22:10:41 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:47371 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab3FWCKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jun 2013 22:10:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAAhV-H6s47NUHzbEX5UKYtkei7=s08PPXCMw39_fP_SV7Hv5Vg@mail.gmail.com>
References: <1359527106-22879-1-git-send-email-chenhc@lemote.com>
	<1359527106-22879-4-git-send-email-chenhc@lemote.com>
	<5166ED66.7020307@realitydiluted.com>
	<CAAhV-H6s47NUHzbEX5UKYtkei7=s08PPXCMw39_fP_SV7Hv5Vg@mail.gmail.com>
Date: Sun, 23 Jun 2013 10:10:38 +0800
X-Google-Sender-Auth: uTpdPRj06dw2TkFxSltPB5V4xis
Message-ID: <CAAhV-H58Y_Rd8thj8MWXGCqqGtYJekDKrO-nXYjdp3214jnQ0A@mail.gmail.com>
Subject: Re: [PATCH V9 03/13] MIPS: Loongson: Introduce and use
 cpu_has_coherent_cache feature
From: Huacai Chen <chenhc@lemote.com>
To: "Steven J. Hill" <sjhill@realitydiluted.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>, Hongliang Tao <taohl@lemote.com>,
        Hua Yan <yanh@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven

Is the 3rd patch of V10 is OK to be accepted now? If so, could the
patchset of V10 be merged into 3.11?

Huacai

On Fri, Apr 12, 2013 at 11:07 AM, Huacai Chen <chenhc@lemote.com> wrote:
> Hi, Steven,
>
> Maybe you are misunderstand Loongson-3's "hardware-maintained cache".
> Loongson-3's hardware maintain the cache coherency between multi-cores (also
> maintain coherency between CPU-core and DMA), but Loongson-3 can *still* has
> cache alias (Cache alias in Loongson is sovled by 16K PageSize).
>
> Meanwhile, I know why you misunderstand, because my code is like this:
>
>
> static inline void local_r4k___flush_cache_all(void * args)
>         if (cpu_has_coherent_cache)
>                 return;
>
> This implies that Loongson-3 has no cache alias, but in fact this is wrong
> if Loongson has configured PageSize < 16K.
>
> I think I should make my code in all flush functions like this:
>
> static inline void local_r4k___flush_cache_all(void * args)
>         if (cpu_has_coherent_cache && !cpu_has_dc_aliases)
>                 return;
>
> Am I right?
>
>
> On Fri, Apr 12, 2013 at 1:05 AM, Steven J. Hill <sjhill@realitydiluted.com>
> wrote:
>>
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>>
>> On 01/30/2013 12:24 AM, Huacai Chen wrote:
>> > Loongson-3 maintains cache coherency by hardware. So we introduce a cpu
>> > feature named cpu_has_coherent_cache and use it to modify MIPS's cache
>> > flushing functions.
>> >
>> > Signed-off-by: Huacai Chen <chenhc@lemote.com> Signed-off-by: Hongliang
>> > Tao
>> > <taohl@lemote.com> Signed-off-by: Hua Yan <yanh@lemote.com> ---
>> > arch/mips/include/asm/cacheflush.h                 |    6 +++++
>> > arch/mips/include/asm/cpu-features.h               |    3 ++
>> > .../asm/mach-loongson/cpu-feature-overrides.h      |    6 +++++
>> > arch/mips/mm/c-r4k.c                               |   21
>> > ++++++++++++++++++- 4 files changed, 34 insertions(+), 2 deletions(-)
>> >
>> Hello.
>>
>> This patch masks the problem that you are not properly probing your L1
>> caches
>> to start with. For some reason in 'probe_pcache()' you reach the default
>> case
>> where the primary data cache is marked as having aliases. If your CPU
>> truly is
>> HW coherent with no aliases, then MIPS_CACHE_ALIASES should never get set.
>> Fixing this would eliminate the 'arch/mips/include/asm/cacheflush.h' and
>> 'arch/mips/mm/c-r4k.c' changes completely. There is no need to add more
>> CPU
>> feature bits for this single platform, thus changes to 'cpu-features.h'
>> and
>> 'cpu-features-overrides.h' will not be accepted.
>>
>> Also, please do not copy the <linux-kernel@vger.kernel.org> mailing list
>> unless your patch touches files outside of 'arch/mips' in order to cut
>> down
>> traffic on an already busy list. Thanks.
>>
>> Steve
>> - -----
>> <sjhill@mips.com>
>> <Steven.Hill@imgtec.com>
>> -----BEGIN PGP SIGNATURE-----
>> Version: GnuPG v1.4.11 (GNU/Linux)
>> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>>
>> iEYEARECAAYFAlFm7WAACgkQgyK5H2Ic36eHuwCeKZjp1+arkoheEpeuzjJkQskN
>> /7MAnig14A03hWxRvfqDOMbMFKXpZBO8
>> =HRPU
>> -----END PGP SIGNATURE-----
>>
>
