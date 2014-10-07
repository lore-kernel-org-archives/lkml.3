Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741AbaJGFpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 01:45:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:33729 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430AbaJGFpb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 01:45:31 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s975jGsO032675, This message is accepted by code: ctloc85258
From: Hau <hau@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net-next] r8169:add support for RTL8168EP
Thread-Topic: [PATCH v2 net-next] r8169:add support for RTL8168EP
Thread-Index: AQHP3utXPbfOR7DfDU2GBQvdbyj53pweTmwAgAR3zKCAAFsqAIABA61A
Date: Tue, 7 Oct 2014 05:45:16 +0000
Message-ID: <80377ECBC5453840BA8C7155328B5377658B3F@RTITMBSV03.realtek.com.tw>
References: <1412328052-8480-1-git-send-email-hau@realtek.com>
 <20141003203244.GA19965@electric-eye.fr.zoreil.com>
 <80377ECBC5453840BA8C7155328B537765786D@RTITMBSV03.realtek.com.tw>
 <20141006221250.GA10936@electric-eye.fr.zoreil.com>
In-Reply-To: <20141006221250.GA10936@electric-eye.fr.zoreil.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.179]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Francois Romieu [mailto:romieu@fr.zoreil.com]
> Sent: Tuesday, October 07, 2014 6:13 AM
> To: Hau
> Cc: netdev@vger.kernel.org; nic_swsd; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v2 net-next] r8169:add support for RTL8168EP
> 
> Hau <hau@realtek.com> :
> [...]
> > Do you mean I should collect similar hardware parameters setting into
> > one function ? or I should set hardware parameters according to
> > hardware feature support version?
> 
> static void r8168dp_ocp_write(...)
> [...]
> 
> static void r8168ep_ocp_write(...)
> [...]
> 
> static void ocp_write(...)
> {
> 	switch (...
> 	case ...
> 		r8168dp_ocp_write
> 
> 	case ...
> 		r8168ep_ocp_write
> [...]
> 
> static void rtl8168dp_driver_start(...)
> [...]
> 
> static void rtl8168ep_driver_start(...)
> [...]
> 
> etc.
> 
> Nothing more. At some point the helpers themselves may turn into data
> struct members. Things don't need to be immediately right - if ever.
> However you really want to avoid unrelated changes in your patches:
> shuffling code and changing features at the same time hurts reviews, late
> regression hunts, backports, etc.
> 
> --
> Ueimor
> 

Thanks, I will do that on later patch.
