Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836AbaFIRZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 13:25:57 -0400
Received: from gws07.hcl.com ([192.8.186.130]:9935 "EHLO GWS07.hcl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933644AbaFIRZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 13:25:55 -0400
X-IronPort-AV: E=Sophos;i="4.98,1003,1392143400"; 
   d="scan'208";a="21636561"
From: "Sathish Kumar Balasubramaniam -ERS, HCL Tech" 
	<b-sathishkumar@hcl.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3.14.6 1/1] pinctrl/sh-pfc: fix pfc-r8a7790 pin mux data
 for IPSR5 bug
Thread-Topic: [PATCH 3.14.6 1/1] pinctrl/sh-pfc: fix pfc-r8a7790 pin mux
 data for IPSR5 bug
Thread-Index: AQHPg0316zNVnchdh0SA2IoGvZkgN5toVCWAgAC0WrA=
Date: Mon, 9 Jun 2014 17:25:51 +0000
Message-ID: <5D833673AB94D9489A7F7F73E9E611C814AD9514@chn-hclt-mbs08.HCLT.CORP.HCL.IN>
References: <5D833673AB94D9489A7F7F73E9E611C814AD9363@chn-hclt-mbs08.HCLT.CORP.HCL.IN>
 <19212082.k9WjBDNGR8@avalon>
In-Reply-To: <19212082.k9WjBDNGR8@avalon>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.150.5.114]
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

Oh. Good to see that its already fixed :)
Thanks for your comments.

Regards,
B.Sathish Kumar

-----Original Message-----
From: Laurent Pinchart [mailto:laurent.pinchart@ideasonboard.com] 
Sent: Monday, June 09, 2014 5:38 PM
To: Sathish Kumar Balasubramaniam -ERS, HCL Tech
Cc: Simon Horman; Magnus Damm; Paul Mundt; linux-sh@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.14.6 1/1] pinctrl/sh-pfc: fix pfc-r8a7790 pin mux data for IPSR5 bug

Hi Sathish,

Thank you for the patch. This has already been fixed in v3.15-rc4 by commit
34ce57e9df7d14b52c7613bb2c190e411ca99186 ("sh-pfc: r8a7790: Fix definition of IPSR5").

On Sunday 08 June 2014 19:15:08 Sathish Kumar Balasubramaniam -ERS, HCL Tech
wrote:
> From: Sathish Kumar Balasubramaniam <b-sathishkumar@hcl.com>
> 
> This patch fixes a bug in the list of peripheral functions for the 
> IPSR5 pin mux configuration of the PFC (Pin Function Controller) of 
> the Renesas R-Car
> H2 SoC (R8A7790). There should be exactly 8 values listed for the 
> IP5_23_21 peripheral function which is using 3 bits. But there are 9 
> values present in the list.
> 
> This bug unexpectedly increases the internal position variable by 1 
> which is used by the PFC framework to identify the peripheral 
> function. Due to this bug, peripheral function configuration from 
> IP5_20_18 to IP5_2_0 may not work properly.
> 
> This issue can be easily reproduced by setting the FN_I2C1_SDA ( 
> IP5_9_6 [4]
> ) which has the function value of 9 but the actual function value is 
> set as
> 10 due to this bug.
> 
> ----------------------------------------------------------------------------
> --- --- linux-3.14.6/drivers/pinctrl/sh-pfc/pfc-r8a7790.c.original   
> 2014-06-08 22:03:44.681669692 +0530 +++
> linux-3.14.6/drivers/pinctrl/sh-pfc/pfc-r8a7790.c    2014-06-08
> 22:02:10.361673511 +0530 @@ -4624,7 +4624,7 @@ static const struct 
> pinmux_cfg_reg pinmu
>          /* IP5_23_21 [3] */
>          FN_WE1_N, FN_IERX, FN_CAN1_RX, FN_VI1_G4,
>          FN_VI1_G4_B, FN_VI2_R6, FN_SCIFA0_CTS_N_B,
> -        FN_IERX_C, 0,
> +        FN_IERX_C,
>          /* IP5_20_18 [3] */
>          FN_WE0_N, FN_IECLK, FN_CAN_CLK,
>          FN_VI2_VSYNC_N, FN_SCIFA0_TXD_B, FN_VI2_VSYNC_N_B, 0, 0,
> 
> 
> Signed-off-by: Sathish Kumar Balasubramaniam <b-sathishkumar@hcl.com>

The SoB line should be before the patch content, not after. Beside, it seems that tabs have been converted to spaces. Please use git format-patch to generate patch files, and git send-email to send them.

--
Regards,

Laurent Pinchart



::DISCLAIMER::
----------------------------------------------------------------------------------------------------------------------------------------------------

The contents of this e-mail and any attachment(s) are confidential and intended for the named recipient(s) only.
E-mail transmission is not guaranteed to be secure or error-free as information could be intercepted, corrupted,
lost, destroyed, arrive late or incomplete, or may contain viruses in transmission. The e mail and its contents
(with or without referred errors) shall therefore not attach any liability on the originator or HCL or its affiliates.
Views or opinions, if any, presented in this email are solely those of the author and may not necessarily reflect the
views or opinions of HCL or its affiliates. Any form of reproduction, dissemination, copying, disclosure, modification,
distribution and / or publication of this message without the prior written consent of authorized representative of
HCL is strictly prohibited. If you have received this email in error please delete it and notify the sender immediately.
Before opening any email and/or attachments, please check them for viruses and other defects.

----------------------------------------------------------------------------------------------------------------------------------------------------

