Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbaKSLWR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 06:22:17 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54990 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755138AbaKSLWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 06:22:16 -0500
Message-ID: <546C7D42.6000103@arm.com>
Date: Wed, 19 Nov 2014 11:21:38 +0000
From: Andrew Jackson <Andrew.Jackson@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drm/i2c: tda998x: Allow for different audio sample rates
References: <546B8452.6030701@arm.com> <20141118180036.GC4042@n2100.arm.linux.org.uk>
In-Reply-To: <20141118180036.GC4042@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/14 18:00, Russell King - ARM Linux wrote:
> On Tue, Nov 18, 2014 at 05:39:30PM +0000, Andrew Jackson wrote:
>> On HDMI, the audio data are carried across the HDMI link which is
>> driven by the TDMS clock. The TDMS clock is dependent on the video pixel
>> rate.
>>
>> This patch sets the denominator (Cycle Time Stamp) appropriately
>> allowing the driver to send audio to a wider range of HDMI sinks
>> (i.e. monitors).
> 
> This is actually pointless, because we don't use "manual" CTS mode.
> 
> If the clocks for the video and audio are coherent, then you can program
> both the N and CTS values to allow the sink to properly recover the
> synchronous audio clock.
> 
> However, in most cases, the audio and video clocks are not coherent, and
> since the recovered audio clock has to match the source audio clock, the
> only way this can be done is by the TDA998x (or in fact other HDMI
> encoder) to measure the audio clock rate and generate the CTS value
> itself.
> 
> This is the mode we drive the TDA998x - so the programmed CTS value is
> irrelevant.

My apologies for the noise: I originally created the patch when one of the monitors with which I was working wouldn't play sound as expected.  However, I now find that the monitor plays sound with or without the patch so it must have been something else.  I'd missed the significance of the "auto CTS" comment a few lines earlier (partly because I've no datasheet on the TDA998x).

   Andrew


