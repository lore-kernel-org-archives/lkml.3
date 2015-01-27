Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760120AbbA0V6D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 16:58:03 -0500
Received: from mail-bl2on0113.outbound.protection.outlook.com ([65.55.169.113]:13040
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759484AbbA0V6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 16:58:01 -0500
Message-ID: <1422395873.10544.61.camel@freescale.com>
Subject: Re: [PATCH v2] powerpc/mpic: Add DT option to skip readback after
 EOI
From: Scott Wood <scottwood@freescale.com>
To: Bogdan Purcareata <bogdan.purcareata@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Date: Tue, 27 Jan 2015 15:57:53 -0600
In-Reply-To: <1422371952-1126-1-git-send-email-bogdan.purcareata@freescale.com>
References: <1422371952-1126-1-git-send-email-bogdan.purcareata@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [2601:2:5800:3f7:12bf:48ff:fe84:c9a0]
X-ClientProxiedBy: BLUPR01CA041.prod.exchangelabs.com (25.160.23.31) To
 BN1PR0301MB0724.namprd03.prod.outlook.com (25.160.78.143)
Authentication-Results: freescale.com; dkim=none (message not signed)
 header.d=none;freescale.com; dmarc=none action=none
 header.from=freescale.com;
X-DmarcAction-Test: None
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(3005004);SRVR:BN1PR0301MB0724;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BN1PR0301MB0724;
X-Forefront-PRVS: 046985391D
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(6009001)(24454002)(377424004)(51704005)(23676002)(87976001)(77156002)(40100003)(122386002)(62966003)(103116003)(86362001)(50986999)(33646002)(76176999)(42186005)(110136001)(46102003)(47776003)(92566002)(36756003)(2950100001)(50466002)(50226001)(3826002);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1PR0301MB0724;H:[IPv6:2601:2:5800:3f7:12bf:48ff:fe84:c9a0];FPR:;SPF:None;MLV:sfv;LANG:en;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BN1PR0301MB0724;
X-OriginatorOrg: freescale.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2015 21:57:58.5619
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN1PR0301MB0724
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-27 at 15:19 +0000, Bogdan Purcareata wrote:
> The readback acts as a synchronization mechanism in handling external
> interrupts, making sure the core waits until EOI write completion. This is
> required in certain scenarios, such as when the MPIC communicates with a PCI
> device in posted write mode. If the device uses legacy interrupts, and the CPU
> returns from the interrupt as soon as it fires the EOI write, there is a chance
> to receive spurious interrupts because the line isn't deasserted yet.

The line was deasserted when IACK was read, before the EOI.  The issue
is (in theory at least) the timing of the write to the device versus the
write to EOI, not the timing of MPIC receiving the EOI versus when the
CPU executes rfi.

> +  - mpic-eoi-no-readback
> +      Usage: optional
> +      Value type: <empty>
> +      Definition: The presence of this property specifies that the
> +          MPIC will not issue a readback

s/will not/does not need to/

At this point, given the previous discussion, does anyone object to
removing the readback entirely?  Do we have any evidence that reading
WHOAMI is effective at addressing whatever problem reading EOI made go
away on the relevant platform?

>  when delivering the EOI for an
> +          external interrupt. The readback operation is done by reading
> +          the CPU WHOAMI register after writing to the CPU EOI register.
> +          Originally, this was required due to the fact that the MPIC
> +          operates at lower frequencies,

Why?

-Scott


