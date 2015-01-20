Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbbATQoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 11:44:22 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48347 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751152AbbATQoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 11:44:20 -0500
Date: Tue, 20 Jan 2015 16:44:18 +0000
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Inha Song <ideal.song@samsung.com>,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        sameo@linux.intel.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [alsa-devel] [PATCH v2 RESEND 2/2] mfd: arizona: Update DT
	binding to support OUTn_MONO init_data
Message-ID: <20150120164418.GC14516@opensource.wolfsonmicro.com>
References: <1420185829-24886-1-git-send-email-ideal.song@samsung.com> <1420185829-24886-3-git-send-email-ideal.song@samsung.com> <20150120122005.GA13701@x1> <20150120132001.GA21293@sirena.org.uk> <20150120160248.GK13701@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150120160248.GK13701@x1>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 04:02:48PM +0000, Lee Jones wrote:
> On Tue, 20 Jan 2015, Mark Brown wrote:
> 
> > On Tue, Jan 20, 2015 at 12:20:05PM +0000, Lee Jones wrote:
> > > On Fri, 02 Jan 2015, Inha Song wrote:
> > 
> > > > This patch update DT binding to support OUTn_MONO init_data. Each
> > > > output signal can be configurated as a mono differential output.
> > > > The mono differential configuration is selected using the OUTn_MONO
> > > > registers.
> > 
> > > This requires a DT Ack and an entry in the example.
> > 
> > The DT maintainers have said they're OK with maintainers just merging
> > things if they're comfortable with it (see the bindings specific
> > submitting-patches.txt) and given their workload and general resulting
> > responsiveness it's going to make it difficult go get anything done.
> 
> I only tend to poke the DT guys when I am unsure of something in the
> binding.  In this case it was a doubt whether we should be encoding
> register values inside a property like this.
> 
> I would also be happy to take it with your Ack if you're happy with
> it?

In this case really it is a boolean indicating if the
corresponding output is mono or not. It is handled thusly in the
code:

		if (arizona->pdata.out_mono[i])
			val = ARIZONA_OUT1_MONO;
		else
			val = 0;

Perhaps some further wording tweaks on the Documentation patch
would be appropriate, but certainly I am happy enough with the
binding.

Thanks,
Charles
