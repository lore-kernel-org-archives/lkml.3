Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754Ab3LPU2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:28:18 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:50901 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751926Ab3LPU2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:28:15 -0500
Message-ID: <1387225692.14970.13.camel@x41.thuisdomein>
Subject: Re: [PATCH 2/2] ahci: only attach ICH6-M if it's in SATA mode
From: Paul Bolle <pebolle@tiscali.nl>
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 16 Dec 2013 21:28:12 +0100
In-Reply-To: <20131216155136.GF32509@htj.dyndns.org>
References: <1387190097.9255.31.camel@x41.thuisdomein>
	 <20131216155136.GF32509@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Dec 2013 20:28:12.0548 (UTC) FILETIME=[57853440:01CEFA9D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-16 at 10:51 -0500, Tejun Heo wrote:
> I'm not quite sure about this one.  The patch seems correct on the
> surface but given how old ich6 is at this point, the general
> crappiness of BIOS on ahci front in that era, and that the existing
> code has been working fine for all these years make me very reluctant
> to change it.  e.g. I don't think CLASS_STORAGE_SATA was the only one.
> They used different class for raid too.

Well, raid should only be relevant for ICH6R (which has its own device
ID). The datasheet I've been staring at suggests that ICH6-M is
hardwired to either use PCI_CLASS_STORAGE_SATA or PCI_CLASS_STORAGE_IDE.

> It should be able to figure
> out things given enough test cases but I don't think we have that
> anymore and the benefit (avoding probe failure messages) doesn't seem
> to justify the risk.

That's your call, obviously. And I don't think that hardware like this
is used widely to run release candidates, if at all, so we can't even
consider a see-who-screams-when-their-setup-breaks approach.

Thanks,


Paul Bolle

