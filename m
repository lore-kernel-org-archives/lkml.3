Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbbA2Bl0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:41:26 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:12717 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbbA2BlV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:21 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'gregkh@linuxfoundation.org'" <gregkh@linuxfoundation.org>
CC: "'tranmanphong@gmail.com'" <tranmanphong@gmail.com>,
        "'fabio.estevam@freescale.com'" <fabio.estevam@freescale.com>,
        "'prime.zeng@huawei.com'" <prime.zeng@huawei.com>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Gao, Neil" <Neil.Gao@sonymobile.com>
Date: Thu, 29 Jan 2015 09:41:18 +0800
Subject: RE: [RFC] ion:change ion_cma_allocate return error value
Thread-Topic: [RFC] ion:change ion_cma_allocate return error value
Thread-Index: AdA7Kozv7Sua+a0eT+y5m+uywFwt3wAOf2iQ
Message-ID: <35FD53F367049845BC99AC72306C23D1044A02027E01@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D1044A02027DF9@CNBJMBX05.corpusers.net>
 <20150128184509.GB1178@kroah.com>
In-Reply-To: <20150128184509.GB1178@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: 'gregkh@linuxfoundation.org' [mailto:gregkh@linuxfoundation.org]
> Sent: Thursday, January 29, 2015 2:45 AM
> To: Wang, Yalin
> Cc: 'tranmanphong@gmail.com'; 'fabio.estevam@freescale.com';
> 'prime.zeng@huawei.com'; 'devel@driverdev.osuosl.org'; 'linux-
> kernel@vger.kernel.org'; Gao, Neil
> Subject: Re: [RFC] ion:change ion_cma_allocate return error value
> 
> On Tue, Jan 27, 2015 at 02:04:21PM +0800, Wang, Yalin wrote:
> > This patch change the error return value from -1 to -ENOMEM, so that
> > userspace can get the correct errno, otherwise,
> > -1 will be -EPERM, userspace will print permission deny for allocation
> > failure.
> >
> > Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
> > ---
> >  drivers/staging/android/ion/ion_cma_heap.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> Don't you also need to now change userspace code to properly handle these
> errors?
> 
No, because userspace use strerror() to print errno,
It will print correct error string depending on kernel return
Errno.
