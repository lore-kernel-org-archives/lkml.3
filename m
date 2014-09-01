Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570AbaIAUSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 16:18:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46733 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbaIAUR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 16:17:59 -0400
X-Sasl-enc: Of2Wa+kSZfzaMzMRBy5hNnOmNaR1UdbQU6LsYnUTYDIQ 1409602678
Date: Mon, 1 Sep 2014 17:17:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Conrad Kostecki <ck@conrad-kostecki.de>
Cc: "Linux (Kernel) Mailingliste (linux-kernel@vger.kernel.org)" 
	<linux-kernel@vger.kernel.org>
Subject: Re: Early microcode not being loaded
Message-ID: <20140901201752.GB18675@khazad-dum.debian.net>
References: <d01572d84b834e9d98aef338f7da446a@DB4PR04MB265.eurprd04.prod.outlook.com>
 <20140718212427.GB11098@pd.tnic>
 <4c348de3b92a49c58bf17777873410dd@DB4PR04MB265.eurprd04.prod.outlook.com>
 <06765c8a9ea84f8a81d595e05dcfe10e@DB4PR04MB265.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06765c8a9ea84f8a81d595e05dcfe10e@DB4PR04MB265.eurprd04.prod.outlook.com>
X-GPG-Fingerprint1: 4096R/39CB4807 C467 A717 507B BAFE D3C1  6092 0BD9 E811
 39CB 4807
X-GPG-Fingerprint2: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Sep 2014, Conrad Kostecki wrote:
> -rw-r--r--   1 root     root      1857432 Jul 18 17:01 kernel/x86/microcode/GenuineIntel.bin

That file is way too big.  In fact, it is exactly the size of the newest
".dat" file from Intel.  The kernel doesn't grok that text format, the
microcode updates have to be converted to binary format, first.

I suggest you use "iucode_tool -S --write-earlyfw=ucode.cpio" to generate
your ucode.cpio.

You can find iucode-tool at:
https://gitorious.org/iucode-tool/pages/Home

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
