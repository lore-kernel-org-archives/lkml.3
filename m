Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752067AbaBQIh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:37:26 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:61261 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbaBQIhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:37:25 -0500
Message-ID: <1392626238.10966.7.camel@x220>
Subject: Re: [PATCH] arm: sti: Remove SOC_STIH415 and SOC_STIH416
From: Paul Bolle <pebolle@tiscali.nl>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        Stuart Menefy <stuart.menefy@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Richard Weinberger <richard@nod.at>, kernel@stlinux.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Feb 2014 09:37:18 +0100
In-Reply-To: <5301C0D2.8040408@st.com>
References: <1392577524.28866.32.camel@x220> <5301C0D2.8040408@st.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Feb 2014 08:37:24.0984 (UTC) FILETIME=[7B9D9F80:01CF2BBB]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Mon, 2014-02-17 at 08:57 +0100, Maxime Coquelin wrote:
> On 02/16/2014 08:05 PM, Paul Bolle wrote:
> > The Kconfig symbols SOC_STIH415 and SOC_STIH416 were added in v3.11.
> > They have never been used. They default to "y" but nothing cares. They
> > can safely be removed.
> 
> This is going to be used by the reset controller series from Srinivas:
> http://marc.info/?l=linux-arm-kernel&m=139143833415806&w=2

That links to a patch containing this chunk:
    @@ -28,6 +29,7 @@ if ARCH_STI
     config SOC_STIH415
 	bool "STiH415 STMicroelectronics Consumer Electronics family"
 	default y
    +	select STIH415_RESET
 	help
 	  This enables support for STMicroelectronics Digital Consumer
 	  Electronics family StiH415 parts, primarily targeted at set-top-box
    @@ -37,6 +39,7 @@ config SOC_STIH415
     config SOC_STIH416
 	bool "STiH416 STMicroelectronics Consumer Electronics family"
 	default y
    +	select STIH416_RESET
 	help
 	  This enables support for STMicroelectronics Digital Consumer
 	  Electronics family StiH416 parts, primarily targeted at set-top-box

Those select statements do not use SOC_STIH415 or SOC_STIH416.

If SOC_STIH415 or SOC_STIH416 are going to be used in the future they
can be readded in the series that also adds users for them.


Paul Bolle

