Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbbA2Bwa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:52:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340AbbA2BwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:21 -0500
Date: Wed, 28 Jan 2015 10:45:09 -0800
From: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'tranmanphong@gmail.com'" <tranmanphong@gmail.com>,
        "'fabio.estevam@freescale.com'" <fabio.estevam@freescale.com>,
        "'prime.zeng@huawei.com'" <prime.zeng@huawei.com>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Gao, Neil" <Neil.Gao@sonymobile.com>
Subject: Re: [RFC] ion:change ion_cma_allocate return error value
Message-ID: <20150128184509.GB1178@kroah.com>
References: <35FD53F367049845BC99AC72306C23D1044A02027DF9@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1044A02027DF9@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 02:04:21PM +0800, Wang, Yalin wrote:
> This patch change the error return value from -1 to -ENOMEM,
> so that userspace can get the correct errno, otherwise,
> -1 will be -EPERM, userspace will print permission deny for allocation
> failure.
> 
> Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> ---
>  drivers/staging/android/ion/ion_cma_heap.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Don't you also need to now change userspace code to properly handle
these errors?

greg k-h
