Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaCDT02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:26:28 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:1895 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751494AbaCDT00 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:26:26 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z579ehz98dIc89bh936eI4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h906i1155h)
Date: Tue, 4 Mar 2014 11:26:05 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Eli Billauer <eli.billauer@gmail.com>
CC: <chris@printf.net>, <michal.simek@xilinx.com>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: Re: [PATCH v2] mmc: sdhci: add quirk for broken write protect
 detection
References: <1393759200-22819-1-git-send-email-eli.billauer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <1393759200-22819-1-git-send-email-eli.billauer@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <74003aec-1707-4f43-b947-df148d573fa1@TX2EHSMHS038.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eli,

On Sun, 2014-03-02 at 01:20PM +0200, Eli Billauer wrote:
> The write protection signal is absent on a board based upon Xilinx' Zynq
> processor ("ZyBo"). This leads the kernel to think that the MicroSD card is
> write protected, and causes a kernel panic during boot, as root fails to
> mount RW.

I talked to some people here at Xilinx. According to them, you have the
option to pin out the WP signal, which would mean the board needs to
tie/connect the signal properly. Or, if you select to not pin out the WP
signal, it should be tied to 0 within the chip.
Currently, I have some doubts that is the case, since Mike reported the
same issue, but would you mind double checking?
In theory the signal should default to logic zero which would at most
require to add the, already existing, 'wp-inverted' quirk when using
micro-sd on Zynq.

	Thanks,
	Sören


