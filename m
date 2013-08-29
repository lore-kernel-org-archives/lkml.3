Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab3H2SOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 14:14:45 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:7978
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753943Ab3H2SOo convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 14:14:44 -0400
X-Forefront-Antispam-Report: CIP:62.221.5.235;KIP:(null);UIP:(null);IPV:NLI;H:xir-gw1;RD:unknown-62-221-5-235.ipspace.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z551biz98dI9371I542I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275dh1de097hz2fh95h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1be0h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h192ch)
From: Michal Simek <michal.simek@xilinx.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Soren Brinkmann <sorenb@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
Thread-Topic: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
Thread-Index: AQHOo2xiWGrQd/Itjk+INlTnWGuysZmsIlEAgABPOV+AAA1FQA==
Date: Thu, 29 Aug 2013 18:14:38 +0000
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <201308291537.54608.arnd@arndb.de>
 <89b68978-7eeb-43e1-a456-d864ed313da5@DB8EHSMHS026.ehs.local>
 <201308291920.13983.arnd@arndb.de>
In-Reply-To: <201308291920.13983.arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.24.214]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <8bcbe8e7-65c9-48b2-a854-f3bec600c6a8@DB9EHSMHS025.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

> -----Original Message-----
> From: Arnd Bergmann [mailto:arnd@arndb.de]
> Sent: Thursday, August 29, 2013 7:20 PM
> To: Michal Simek
> Cc: Sebastian Hesselbarth; Soren Brinkmann; Mike Turquette; Russell King;
> linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH RFC v2 16/16] ARM: zynq: Don't call of_clk_init()
>
> On Thursday 29 August 2013, Michal Simek wrote:
> > Is there any plan to remove all of them?
> > I expect that on almost all platforms it is a need to have at least
> > one early hook to be able to setup things.
>
> In an ideal world, we wouldn't need any, and on arm64 we don't plan to
> introduce callbacks in the first place. We don't put a lot of effort into eliminating
> all the ones from existing platforms in the near future, but but I do hope to have
> a situation where we don't use any callbacks for newly introduced 32-bit
> platforms soon, and remove a lot of the existing callbacks over time when we
> have the chance (like now for the clk init).

As you know we are open to change this when we have alternative for doing that.
I have read discussion about early device probing. Especially for this slcr case.
It is giant IP where generic locking is, clock stuff, pin muxing, reset, cpu startup.
It points to use syscon and regmap and I would love to use better solution
but slcr unlocking must be done very early for clock setup and smp startup.
If you know how to do it let me know. I am definitely open to try that solution.

I expect that this topic will be discussed on ksummit or at least on arm minisummit.

Thanks,
Michal



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.


