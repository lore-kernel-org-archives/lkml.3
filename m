Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbaAGSa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 13:30:57 -0500
Received: from mail-ea0-f173.google.com ([209.85.215.173]:46056 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbaAGSat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 13:30:49 -0500
Message-ID: <52CC47D0.8070606@gmail.com>
Date: Tue, 07 Jan 2014 20:30:40 +0200
From: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Tomi Valkeinen <tomi.valkeinen@ti.com>
CC: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        "pali.rohar@gmail.com" <pali.rohar@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: OMAPDSS: DISPC: horizontal timing too tight errors
References: <52CA7ABB.4010401@gmail.com> <52CBF476.3070306@ti.com> <20140107180509.GC18316@amd.pavel.ucw.cz>
In-Reply-To: <20140107180509.GC18316@amd.pavel.ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07.01.2014 20:05, Pavel Machek wrote:
> On Tue 2014-01-07 14:35:02, Tomi Valkeinen wrote:
>> On 2014-01-06 11:43, Ivaylo Dimitrov wrote:
>>> Hi,
>>>
>>> commit 7faa92339bbb1e6b9a80983b206642517327eb75 "OMAPDSS: DISPC: Handle
>>> synclost errors in OMAP3" introduces some limits check to prevent
>>> SYNCLOST errors on OMAP3 in a specific usecase. The problem I see here
>>> (on Nokia N900, Maemo 5, linux 3.13-rc6, DSP accel video decoding) is
>>> that those checks effectively prevent fullscreen video playback of
>>> anything above lets say 640x350 with "horizontal timing too tight"
>>> errors spit in dmesg log. If I hack check_horiz_timing_omap3 function to
>>> always return true, I can happily play videos up to (and including) 720p
>>> resolutions, with no SYNCLOST errors.
>>
>> I never worked with the patch in question, but my understanding is that
>> the core issue is quite difficult to solve optimally for all cases.
>> There are so many variables involved. So it may well be that the patch
>> in question does it a bit over-safely. Then again, it might as well have
>> a bug =).
>
> Can we simply revert 7faa92339bbb1e6b9a80983b206642517327eb75 ?
>
> Working around undocumented problems on unspecified machine, but
> breaking configuration people actually use seems like a bad idea.
>
> 									Pavel
>
The similar code exists in both omap1(N900 stock) and N9 kernels, I 
guess there is some other bug (somewhere else), trying to find it as we 
speak :)

Ivo
