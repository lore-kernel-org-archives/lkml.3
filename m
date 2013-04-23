Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3DWIb1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 04:31:27 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:48131 "EHLO
	centos1.newflow.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756007Ab3DWIbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 04:31:19 -0400
Message-ID: <517646D5.9090700@newflow.co.uk>
Date: Tue, 23 Apr 2013 09:31:17 +0100
From: Mark Jackson <mpfj-list@newflow.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>
CC: dedekind1@gmail.com,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: MTD : cannot reserve enough PEBs for bad PEB handling [SOLVED]
References: <51750526.70508@newflow.co.uk>
In-Reply-To: <51750526.70508@newflow.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/13 10:38, Mark Jackson wrote:
> I'm trying to work out how to generate a "valid" UBI image, but I keep
> getting a "cannot get enough PEBs" warning.
> 
> I generate my image (destined for a 64MB NAND partition) using:-
> 
> $ mkfs.ubifs -d output/target -e 0x1f000 -c 483 -m 0x800 -x none -F -o
> output/images/rootfs.ubifs
> $ ubinize -o output/images/rootfs.ubi -m 0x800 -p 0x20000 -s 512 -O 2048
> ubinize.cfg
> 
> My .cfg file is:-
> 
> [ubifs]
> mode=ubi
> vol_id=0
> vol_type=dynamic
> vol_name=rootfs
> vol_alignment=1
> vol_flags=autoresize
> vol_size=61MiB

I just removed this vol_size entry and it all seems to be fine now.

I guess this was too big ??

Mark J.
