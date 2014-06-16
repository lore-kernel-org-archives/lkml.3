Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbaFPJ4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 05:56:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:48374 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816AbaFPJ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 05:56:35 -0400
Date: Mon, 16 Jun 2014 12:56:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Martyn Welch <martyn.welch@ge.com>
Cc: nick <nickkrause@sympatico.ca>, manohar.vanga@gmail.com,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: =?utf-8?B?UEFUQ0hbW3ZtZS9icmlkZ2VzL3Zt?=
 =?utf-8?B?ZV9jYTkxY3g0Mi5jOjEzODI6IEJhZCBpZiB0ZXN0IEJ1ZyBGaXhd4oCP4oCP?=
Message-ID: <20140616095631.GN5015@mwanda>
References: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
 <539EBD2D.9030504@ge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539EBD2D.9030504@ge.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 10:47:25AM +0100, Martyn Welch wrote:
> Nick,
> 
> Sorry for the delay in responding.
> 
> I'm staring at the manual for the ca91c142 and the relevant bits in
> the VSIx_CTL registers definitely need to be set to 0 for A16,
> likewise with the LM_CTL register. The pattern (3<<16) would enable
> one of the "reserved" address spaces.
> 

Nick emailed me privately that this was a static checker warning.  These
warnings are often false positives...  But I'm worried about the test:

	if ((ctl & CA91CX42_VSI_CTL_VAS_M) == CA91CX42_VSI_CTL_VAS_A16)
		*aspace = VME_A16;

That could be true when we didn't intend it.

regards,
dan carpenter

