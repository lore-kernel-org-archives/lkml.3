Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752164Ab3EPE2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 00:28:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:31971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab3EPE2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 00:28:51 -0400
X-IronPort-AV: E=Sophos;i="4.87,681,1363158000"; 
   d="scan'208";a="47797321"
Message-ID: <51946082.1000606@codeaurora.org>
Date: Wed, 15 May 2013 21:28:50 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Philip Balister <philip@balister.org>,
        linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <20130512143344.GC3200@sirena.org.uk> <9e55c552-ce34-4663-9a57-bf2c626d7d58@TX2EHSMHS008.ehs.local> <20130513052135.GD6836@sirena.org.uk> <0bf5a185-86f7-4a93-a90f-42caefb06a1d@TX2EHSMHS009.ehs.local> <519112F9.2010102@gmail.com> <7c5e7537-6ed5-4622-a7a9-bf46820ef695@VA3EHSMHS033.ehs.local> <519124D3.2040403@gmail.com> <af51c63e-7ff1-4e73-9305-08309217ab38@TX2EHSMHS037.ehs.local> <20130514164611.10068.46384@quantum> <51927DEB.7090001@balister.org> <20130515044604.GA24524@sirena.org.uk>
In-Reply-To: <20130515044604.GA24524@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 09:46 PM, Mark Brown wrote:
> On Tue, May 14, 2013 at 02:09:47PM -0400, Philip Balister wrote:
>
>> First of all, the driver that loads the bitstream into the fpga
>> fabric does not know ANYTHING about what the bitstream does. So it
>> cannot do any setup based on the contents of the file that is
>> loaded. (And this can also be loaded during the SoC bootup,
>> bypassing this driver completely)
>
> This is a problem that is going to need to be fixed - there will be some
> things going on the FPGAs that do need drivers and so there needs to be
> some way to instantiate a driver for a FPGA image.  Things like adding
> extra DT blobs along with the FPGA image have been talked about
>
>> Second, there are four clocks that feed the FPGA fabric. We will
>> want to set these clocks from user space somehow. It is perfectly
>> valid to use a uio driver to interface with logic in the fpga. If we
>> take the approach of using such general purpose techniques to
>> interface with fpga logic, we must have ways for the user to control
>> the fpga clocks.
>
> Right, and if the specific device is being controlled by UIO then having
> UIO create some clocks makes sense but then that should be integrated
> into the UIO instantiation rather than done as a separate thing.

Agreed. I was about to reply with exactly the same point. I haven't done 
any UIO coding, but that device file will eventually have to be opened. 
Turn on the clocks in the open and turn them off at close.

Rate to request can be a DT property.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
