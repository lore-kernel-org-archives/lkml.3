Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753196AbaIOOj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:39:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:53661 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaIOOj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:39:26 -0400
X-IronPort-AV: E=Sophos;i="5.04,528,1406592000"; 
   d="scan'208";a="171562139"
Message-ID: <5416FA0C.6090703@citrix.com>
Date: Mon, 15 Sep 2014 15:39:08 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
CC: <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] drivers/xen/xenbus/xenbus_client.c: Improve the failure
 processing for __xenbus_switch_state()
References: <54157282.40402@gmail.com> <5415737D.2030209@gmail.com>
In-Reply-To: <5415737D.2030209@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/09/14 11:52, Chen Gang wrote:
> When failure occurs, need return failure code instead of 0, or the upper
> caller will misunderstand.
> 
> Also when retry for EAGAIN reason, better to schedule out for a while,
> so can let others have chance to continue their tasks (especially,
> their tasks are related EAGAIN under UP kernel).

Is this fixing a real world problem you have seen?

xenbus_scanf() and xenbus_printf() already sleep while waiting for the
response and delaying isn't going to reduce the likelihood of the
transaction being aborted on the retry.

David
