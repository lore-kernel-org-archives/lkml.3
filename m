Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751958Ab3FYIDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 04:03:43 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:13760 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab3FYIDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 04:03:39 -0400
X-IronPort-AV: E=Sophos;i="4.87,934,1363132800"; 
   d="scan'208";a="6017013"
Message-ID: <51C94ED7.30006@citrix.com>
Date: Tue, 25 Jun 2013 10:03:35 +0200
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] xen-blkback: check the number of iovecs before
 allocating a bios
References: <1371812216-17093-4-git-send-email-roger.pau@citrix.com> <1371887957-18301-1-git-send-email-roger.pau@citrix.com> <20130624132841.GA21144@phenom.dumpdata.com>
In-Reply-To: <20130624132841.GA21144@phenom.dumpdata.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/06/13 15:28, Konrad Rzeszutek Wilk wrote:
> On Sat, Jun 22, 2013 at 09:59:17AM +0200, Roger Pau Monne wrote:
>> With the introduction of indirect segments we can receive requests
>> with a number of segments bigger than the maximum number of allowed
>> iovecs in a bios, so make sure that blkback doesn't try to allocate a
>> bios with more iovecs than BIO_MAX_PAGES
> 
> Shouldn't we just gate the feature-indirect-descriptor value to
> take this into account?
> 
> What happens if the nseg is > BIO_MAX_PAGES? Do we "lose" the request
> for the remaining segments?

No, we just allocate several bios in order to send the request to the
underlying device.
