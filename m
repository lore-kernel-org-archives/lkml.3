Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860Ab3GKOsB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 10:48:01 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:20241 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932730Ab3GKOr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 10:47:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="6588557"
Message-ID: <51DEC59B.2040501@citrix.com>
Date: Thu, 11 Jul 2013 16:47:55 +0200
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 2/4] xen-blkfront: improve aproximation
 of	required grants per request
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-3-git-send-email-roger.pau@citrix.com> <51DEB102.7060802@citrix.com>
In-Reply-To: <51DEB102.7060802@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/13 15:20, David Vrabel wrote:
> On 08/07/13 14:03, Roger Pau Monne wrote:
>> Improve the calculation of required grants to process a request by
>> using nr_phys_segments instead of always assuming a request is going
>> to use all posible segments.
> 
> This isn't obviously correct to me.  Why is this correct value for the
> number of pages that need to be granted?

This contains the number of scatter-gather DMA addr+len pairs, which is
basically what we put at every granted page. for_each_sg iterates over
the DMA addr+len pairs and uses a grant page for each of them.
