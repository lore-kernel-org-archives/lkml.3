Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375AbaJFWNA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 18:13:00 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:46720 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbaJFWM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 18:12:58 -0400
Date: Tue, 7 Oct 2014 00:12:50 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hau <hau@realtek.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] r8169:add support for RTL8168EP
Message-ID: <20141006221250.GA10936@electric-eye.fr.zoreil.com>
References: <1412328052-8480-1-git-send-email-hau@realtek.com>
 <20141003203244.GA19965@electric-eye.fr.zoreil.com>
 <80377ECBC5453840BA8C7155328B537765786D@RTITMBSV03.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80377ECBC5453840BA8C7155328B537765786D@RTITMBSV03.realtek.com.tw>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hau <hau@realtek.com> :
[...]
> Do you mean I should collect similar hardware parameters setting into one
> function ? or I should set hardware parameters according to hardware
> feature support version?

static void r8168dp_ocp_write(...)
[...]

static void r8168ep_ocp_write(...)
[...]

static void ocp_write(...)
{
	switch (...
	case ...
		r8168dp_ocp_write

	case ...
		r8168ep_ocp_write
[...]

static void rtl8168dp_driver_start(...)
[...]

static void rtl8168ep_driver_start(...)
[...]

etc.

Nothing more. At some point the helpers themselves may turn into data
struct members. Things don't need to be immediately right - if ever.
However you really want to avoid unrelated changes in your patches:
shuffling code and changing features at the same time hurts reviews,
late regression hunts, backports, etc.

-- 
Ueimor
