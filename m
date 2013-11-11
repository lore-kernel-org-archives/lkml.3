Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab3KKMa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 07:30:29 -0500
Received: from li42-95.members.linode.com ([209.123.162.95]:36312 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab3KKMaS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 07:30:18 -0500
Subject: Re: [PATCH v3 3/3] DT: proc: Add runtime overlay interface in /proc
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <5280AFCF.8050208@nsn.com>
Date: Mon, 11 Nov 2013 13:30:08 +0100
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Matt Porter <matt.porter@linaro.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        Alison Chaiken <Alison_Chaiken@mentor.com>,
        Dinh Nguyen <dinh.linux@gmail.com>, Jan Lubbe <jluebbe@lasnet.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        Michael Stickel <ms@mycable.de>, Guenter Roeck <linux@roeck-us.net>,
        Dirk Behme <dirk.behme@gmail.com>,
        Alan Tull <delicious.quinoa@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Bohan <mbohan@codeaurora.org>, Michal Simek <monstr@monstr.eu>,
        Matt Ranostay <mranostay@gmail.com>, Joel Becker <jlbec@evilplan.org>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <21339C1D-0442-4755-AC7E-1900BF624548@antoniou-consulting.com>
References: <1383923170-24914-1-git-send-email-panto@antoniou-consulting.com> <1383923170-24914-4-git-send-email-panto@antoniou-consulting.com> <5280AFCF.8050208@nsn.com>
To: Ionut Nicu <ioan.nicu.ext@nsn.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ionut,

On Nov 11, 2013, at 11:22 AM, Ionut Nicu wrote:

> Hi,
> 
> On 08.11.2013 16:06, ext Pantelis Antoniou wrote:
>> Add a runtime interface to /proc to enable generic device tree overlay
>> usage.
>> 
> 
>> +
>> +		/* start at 256K at first */
>> +		if (od->alloc == 0)
>> +			od->alloc = SZ_256K / 2;
>> +
> 
> Same problem as Guenter reported. I have to include <linux/sizes.h> or otherwise
> the code will not build.
> 

OK, I guess on my platform it gets implicitly included.

>> +	rcu_read_lock();
>> +	idr_for_each_entry(&overlay_idr, od, id) {
>> +		seq_printf(m, "%d: %d bytes", id, od->size);
> 
> For od->size we should use "%zu", otherwise there will be a compilation warning.
> At least I get one on mips64...
> 

Both of these will be included on the next revision of the patchset.

> Otherwise, I've tested this and it works fine for me also.
> 
> Thanks,
> Ionut

Regards

-- Pantelis

