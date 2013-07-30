Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab3G3Uxh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:53:37 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:7596 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123Ab3G3Uxf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:53:35 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 30 Jul 2013 13:52:10 -0700
From: Andrew Chew <AChew@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
CC: "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>,
        "j-keerthy@ti.com" <j-keerthy@ti.com>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        Rhyland Klein <rklein@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 30 Jul 2013 13:53:32 -0700
Subject: RE: [PATCH] mfd: palmas: Add DVFS mux setting
Thread-Topic: [PATCH] mfd: palmas: Add DVFS mux setting
Thread-Index: Ac6NYjfx9/s/TdTKTLuFEvla2/xk8wABHpAw
Message-ID: <643E69AA4436674C8F39DCC2C05F763862A1274697@HQMAIL03.nvidia.com>
References: <1374871308-490-1-git-send-email-achew@nvidia.com>
 <51F2E74E.2060107@wwwdotorg.org>
 <643E69AA4436674C8F39DCC2C05F763862A12740FB@HQMAIL03.nvidia.com>
 <51F2EC66.2080200@wwwdotorg.org>
 <643E69AA4436674C8F39DCC2C05F763862A1274113@HQMAIL03.nvidia.com>
 <51F2F22B.500@wwwdotorg.org>
 <643E69AA4436674C8F39DCC2C05F763862A1274137@HQMAIL03.nvidia.com>
 <51F398F8.5070602@nvidia.com> <51F81FF5.4020600@wwwdotorg.org>
In-Reply-To: <51F81FF5.4020600@wwwdotorg.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 07/27/2013 03:55 AM, Laxman Dewangan wrote:
> > On Saturday 27 July 2013 03:42 AM, Andrew Chew wrote:
> >> I wrote:
> >>> Andrew wrote:
> >>>> [adding a third pinmux configuration property to Palmas's DT]
> >>>
> >>> How does this interact with the pinctrl driver that Laxman just sent
> >>> for Palmas?
> >>>
> >>> https://lkml.org/lkml/2013/7/26/141
> >>> [PATCH 0/2] pinctrl: palmas: add pincontrol driver
> ..
> >> Abandoning this patch.
> ...
> > once we will have the pincontrol driver then mux pads are become
> redundant.
> 
> OK. The driver should probably operate like this then:
> 
> * During probe(), parse the ti,mux-pad* parameters, if present, and apply
> them. This is needed to maintain compatibility with old DTs that may contain
> these properties.
> 
> * At the end of probe(), register the pinctrl driver. If standard pinctrl
> properties are present in DT, these will then be applied. These may override
> the values set by any ti,mux-pad* properties if they were present.
> 
> Also, we should remove, or mark deprecated, the ti,mux-pad* properties in
> the binding document when adding pinctrl support.

Sounds reasonable to me.  The fate of my patch hasn't really been discussed, though.
Can we apply it, to make the ti,mux-pad* stuff complete?
