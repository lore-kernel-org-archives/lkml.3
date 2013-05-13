Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3EMSSO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 14:18:14 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:57205 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752642Ab3EMSSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 14:18:13 -0400
Message-ID: <51912E5F.9090401@gmail.com>
Date: Mon, 13 May 2013 20:18:07 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Mark Brown <broonie@kernel.org>, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com> <20130510212422.GY3200@sirena.org.uk> <7e18bed3-ae6b-4aa0-bf23-b6c61ba8b85b@CO9EHSMHS030.ehs.local> <20130512143344.GC3200@sirena.org.uk> <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local> <20130513052135.GD6836@sirena.org.uk> <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local> <519112F9.2010102@gmail.com> <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local> <519124D3.2040403@gmail.com> <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
In-Reply-To: <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/13 19:58, Sören Brinkmann wrote:
> On Mon, May 13, 2013 at 07:37:23PM +0200, Sebastian Hesselbarth wrote:
>> It is, as it will only expose clocks on Zynq and that's what Mark and
>> Mike are worried about. Expose clocks to user space and you will have
>> people mess with it for sure.
> Well, even if you contain it in that driver you can still mess with
> other clocks. Just give it the "wrong" input clock references in DT and
> you are free to control them. As I said before, there is no protection
> against such misuse.

Put the wrong clock in DT is not "misuse" but "bug" ;) More important,
it is quite static as you cannot change it easily by echo'ing into some
sysfs file. And to inject a DT you need access on boot loader level,
not kernel user space (yet).

>> About the shape of it, I didn't expect that to change at all. Just
>> wondering, if it still requires you to manually end it's endianess
>> mess with the bitfiles. If you go at it, consider reading the magic
>> hidden in the bitfile and swap it when it is required. But that will
>> go OT here.
> It still takes byteswapped, binary images as input, unfortunately.

Please, if you ever mainline any kernel driver for it, make it
auto-swap.

>> If you don't want to merge both drivers, have a Zynq-only clock
>> fabric driver instead?
> That was my original intention. But due to the nature of it, it will
> always be possible to use it with other clocks too. Hence my generic
> approach.

I already tried a generic "expose clocks to user space" and failed for
the very same reasons Mike and Mark are repeating over and over again -
and I agree with them.

> I actually like the idea of making it part of the device config driver.
> The downside of it is, that this driver seems a bit far from mainline.

Have a skeleton driver that exposes Zynq clocks first and implement
device config later? IIRC, device config isn't that complicated to
implement. Unfortunately, interpreting Xilinx datasheets or source code
is.

Sebastian
