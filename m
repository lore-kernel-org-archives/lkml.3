Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab3K0KH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 05:07:57 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:50276 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3K0KHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 05:07:53 -0500
Date: Wed, 27 Nov 2013 11:07:41 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Miroslav Lichvar <mlichvar@redhat.com>, linux-kernel@vger.kernel.org,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH RFC] timekeeping: Fix clock stability with nohz
Message-ID: <20131127100739.GB4609@netboy>
References: <1384440640-9482-1-git-send-email-mlichvar@redhat.com>
 <20131116070304.GB4355@netboy>
 <528A8667.7000304@linaro.org>
 <20131119141319.GA6934@netboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119141319.GA6934@netboy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 03:13:19PM +0100, Richard Cochran wrote:
> 
> In this test, the update rate is once per second. When using longer
> intervals, the problem becomes worse.

Here is another pair of example runs on an idle system, this time with
a 32 second update interval.

* Periodic Case

  CONFIG_HZ_PERIODIC=y
  CONFIG_NO_HZ=y
  CONFIG_HZ_1000=y

  The peak to peak time error is about 600 nanoseconds.

sudo ./phc2sys -s eth3 -m -q -l7 -O0 -P0 -I0 -R.03125
phc2sys[118.045]: PI servo: sync interval 32.000 kp 0.022 ki 0.009375
phc2sys[150.045]: sys offset    894205 s0 freq      +0 delay   5172
phc2sys[182.045]: sys offset   1416429 s1 freq  +16319 delay   5176
phc2sys[214.045]: sys offset         7 s2 freq  +16320 delay   5172
phc2sys[246.045]: sys offset       140 s2 freq  +16324 delay   5179
phc2sys[278.045]: sys offset       346 s2 freq  +16332 delay   5171
phc2sys[310.045]: sys offset       494 s2 freq  +16339 delay   5184
phc2sys[342.046]: sys offset       485 s2 freq  +16344 delay   5191
phc2sys[374.046]: sys offset       251 s2 freq  +16341 delay   5172
phc2sys[406.046]: sys offset       153 s2 freq  +16340 delay   5174
phc2sys[438.046]: sys offset       156 s2 freq  +16342 delay   5193
phc2sys[470.046]: sys offset        39 s2 freq  +16340 delay   5179
phc2sys[502.046]: sys offset       173 s2 freq  +16344 delay   5076
phc2sys[534.046]: sys offset       286 s2 freq  +16349 delay   5171
phc2sys[566.047]: sys offset       130 s2 freq  +16347 delay   5159
phc2sys[598.047]: sys offset       -64 s2 freq  +16342 delay   5191
phc2sys[630.047]: sys offset       176 s2 freq  +16349 delay   5184
phc2sys[662.047]: sys offset       248 s2 freq  +16353 delay   5167
phc2sys[694.047]: sys offset       166 s2 freq  +16353 delay   5187
phc2sys[726.047]: sys offset       227 s2 freq  +16356 delay   5179
phc2sys[758.047]: sys offset        91 s2 freq  +16354 delay   5177
phc2sys[790.048]: sys offset       -12 s2 freq  +16352 delay   5179
phc2sys[822.048]: sys offset       -44 s2 freq  +16351 delay   5189
phc2sys[854.048]: sys offset       -99 s2 freq  +16349 delay   5159
phc2sys[886.048]: sys offset        53 s2 freq  +16352 delay   5184
phc2sys[918.048]: sys offset       241 s2 freq  +16359 delay   5172
phc2sys[950.048]: sys offset       293 s2 freq  +16363 delay   5191
phc2sys[982.048]: sys offset       -92 s2 freq  +16353 delay   5179
phc2sys[1014.048]: sys offset       -61 s2 freq  +16354 delay   5172
phc2sys[1046.049]: sys offset       -42 s2 freq  +16354 delay   5186

* NO_HZ 

  CONFIG_NO_HZ_COMMON=y
  CONFIG_NO_HZ_IDLE=y
  CONFIG_NO_HZ=y
  CONFIG_RCU_FAST_NO_HZ=y
  CONFIG_HZ_250=y

  The peak to peak time error reaches 9.5 microseconds.

sudo ./phc2sys -s eth3 -m -q -l7 -O0 -P0 -I0 -R.03125
phc2sys[2036.649]: PI servo: sync interval 32.000 kp 0.022 ki 0.009375
phc2sys[2068.650]: sys offset   1322846 s0 freq      +0 delay   5184
phc2sys[2100.650]: sys offset   1845801 s1 freq  +16342 delay   5172
phc2sys[2132.650]: sys offset      -643 s2 freq  +16322 delay   5197
phc2sys[2164.650]: sys offset       111 s2 freq  +16340 delay   5192
phc2sys[2196.650]: sys offset     -2110 s2 freq  +16271 delay   5174
phc2sys[2228.650]: sys offset      4545 s2 freq  +16460 delay   5172
phc2sys[2260.650]: sys offset     -3666 s2 freq  +16246 delay   5160
phc2sys[2292.651]: sys offset      4454 s2 freq  +16465 delay   5183
phc2sys[2324.651]: sys offset     -1017 s2 freq  +16336 delay   5166
phc2sys[2356.651]: sys offset     -1248 s2 freq  +16319 delay   5159
phc2sys[2388.651]: sys offset      2824 s2 freq  +16435 delay   5174
phc2sys[2420.651]: sys offset     -2253 s2 freq  +16302 delay   5174
phc2sys[2452.651]: sys offset      -431 s2 freq  +16338 delay   5186
phc2sys[2484.651]: sys offset       374 s2 freq  +16359 delay   5191
phc2sys[2516.652]: sys offset      1198 s2 freq  +16389 delay   5176
phc2sys[2548.652]: sys offset     -1803 s2 freq  +16306 delay   5184
phc2sys[2580.652]: sys offset      -295 s2 freq  +16336 delay   5179
phc2sys[2612.652]: sys offset       753 s2 freq  +16366 delay   5188
phc2sys[2644.652]: sys offset      -907 s2 freq  +16321 delay   5184
phc2sys[2676.652]: sys offset      -128 s2 freq  +16337 delay   5111
phc2sys[2708.652]: sys offset     -2000 s2 freq  +16277 delay   5179
phc2sys[2740.653]: sys offset      2270 s2 freq  +16392 delay   5174
phc2sys[2772.653]: sys offset       718 s2 freq  +16365 delay   5191
phc2sys[2804.653]: sys offset     -1004 s2 freq  +16318 delay   5172
phc2sys[2836.653]: sys offset      -331 s2 freq  +16329 delay   5184
phc2sys[2868.653]: sys offset      1667 s2 freq  +16389 delay   5081
phc2sys[2900.653]: sys offset     -1154 s2 freq  +16316 delay   5192
phc2sys[2932.653]: sys offset      5693 s2 freq  +16519 delay   5184
phc2sys[2964.654]: sys offset     -3833 s2 freq  +16275 delay   5171
 
Thanks,
Richard
