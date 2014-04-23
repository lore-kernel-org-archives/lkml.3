Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaDWRoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:44:46 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:53566 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754146AbaDWRon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:44:43 -0400
X-Auth-Info: ZmkftslnfdR62ZMiF48OoeAn4cB9K/4+DcdSLFkKTHU=
From: Marek Vasut <marex@denx.de>
To: Christian Engelmayer <cengelma@gmx.at>
Subject: Re: [PATCH 1/3] crypto: Fix potential leak in test_aead_speed() if aad_size is too big
Date: Wed, 23 Apr 2014 19:44:41 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20140421204439.7999f1c6@spike> <201404230133.05256.marex@denx.de> <20140423194335.2d72d7a4@spike>
In-Reply-To: <20140423194335.2d72d7a4@spike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404231944.41781.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 23, 2014 at 07:43:35 PM, Christian Engelmayer wrote:
> On Wed, 23 Apr 2014 01:33:05 +0200, Marek Vasut <marex@denx.de> wrote:
> > On Monday, April 21, 2014 at 08:45:59 PM, Christian Engelmayer wrote:
> > > +	if (aad_size >= PAGE_SIZE) {
> > 
> > On an unrelated note ... Won't if (aad_size > PAGE_SIZE) be sufficient
> > here?
> 
> From what I have seen how the buffers are allocated via __get_free_page() I
> thought so too. However, as it previously read
> 
> 	if (aad_size < PAGE_SIZE)
> 		memset(assoc, 0xff, aad_size);
> 	else {
> 
> my intention was simply to make the modification so that the bug is
> addressed without introducing an additional change.

I fully agree with you. I was just curious about the comparison here.

Best regards,
Marek Vasut
