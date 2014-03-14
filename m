Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301AbaCNLcH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:32:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47362 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753257AbaCNLcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:32:06 -0400
Date: Fri, 14 Mar 2014 12:32:02 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] ARM: dts: berlin2q: add the Marvell Armada 1500
 pro
Message-ID: <20140314113202.GB3106@piout.net>
References: <1394719607-25018-1-git-send-email-antoine.tenart@free-electrons.com>
 <1394719607-25018-2-git-send-email-antoine.tenart@free-electrons.com>
 <5322CC8B.6010905@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5322CC8B.6010905@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/2014 at 10:31:55 +0100, Sebastian Hesselbarth wrote :
> On 03/13/2014 03:06 PM, Antoine Ténart wrote:
> >+		local-timer@ad0600 {
> >+			compatible = "arm,cortex-a9-twd-timer";
> >+			reg = <0xad0600 0x20>;
> >+			clocks = <&sysclk>;
> 
> If I understand Jisheng correctly, this should be cpuclk/3. When
> removing the clocks {} container above, please also take care of
> it.
> 

You understood correctly

> You can do
> 
> cpuclk: cpu-clock {
> 	compatible = "fixed-clock";
> 	#clock-cells = <0>;
> 	clock-frequency = <1200000000>; /* <- put correct freq here */
> };
> 
> sysclk: system-clock {
> 	compatible = "fixed-factor-clock";
> 	#clock-cells = <0>;
> 	clocks = <&cpuclk>;
> 	clock-multi = <1>;
> 	clock-div = <3>;
> };
> 
> Hopefully, we'll have proper clock drivers soon so we can just replace
> referenced "fixed-*" clocks.
> 

I'm working on that, do you have some code that you can share right now ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
