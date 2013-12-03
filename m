Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab3LCLHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 06:07:14 -0500
Received: from smtp.citrix.com ([66.165.176.89]:34207 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752318Ab3LCLHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 06:07:11 -0500
X-IronPort-AV: E=Sophos;i="4.93,817,1378857600"; 
   d="scan'208";a="80040094"
From: Paul Durrant <Paul.Durrant@citrix.com>
To: David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@citrix.com>,
        Julien Grall <julien.grall@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: RE: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
Thread-Topic: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
 in public headers
Thread-Index: AQHO8BdKh9Yy/iIgwkqwz56/wm8SE5pCT1xw
Date: Tue, 3 Dec 2013 11:07:08 +0000
Message-ID: <9AAE0902D5BC7E449B7C8E4E778ABCD019DD6B@AMSPEX01CL01.citrite.net>
References: <1386068254-1413-1-git-send-email-roger.pau@citrix.com>
 <529DBA07.6090108@citrix.com>
In-Reply-To: <529DBA07.6090108@citrix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.80.2.29]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: xen-devel-bounces@lists.xen.org [mailto:xen-devel-
> bounces@lists.xen.org] On Behalf Of David Vrabel
> Sent: 03 December 2013 11:01
> To: Roger Pau Monne
> Cc: Stefano Stabellini; Julien Grall; linux-kernel@vger.kernel.org; xen-
> devel@lists.xenproject.org; Boris Ostrovsky
> Subject: Re: [Xen-devel] [PATCH RFC] xen-block: correctly define structures
> in public headers
> 
> On 03/12/13 10:57, Roger Pau Monne wrote:
> > Using __packed__ on the public interface is not correct, this
> > structures should be compiled using the native ABI, and __packed__
> > should only be used in the backend counterpart of those structures
> > (which needs to handle different ABIs).
> >
> > This was even worse in the ARM case, where the Linux kernel was
> > incorrectly using the X86_32 protocol ABI. This patch fixes it, but
> > also breaks compatibility, so an ARM DomU kernel compiled with
> > this patch will fail to communicate with PV disk devices unless the
> > Dom0 also has this patch.
> 
> This ABI change needs to be justified.  Why do you think it is
> acceptable to break existing Linux guests?  Because I don't think it is.
> 

Even if they are lying about their ABI?

   Paul

> David
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
