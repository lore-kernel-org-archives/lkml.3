Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaFLUwZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 16:52:25 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17623 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaFLUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 16:52:24 -0400
Date: Thu, 12 Jun 2014 23:52:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: nick <nickkrause@sympatico.ca>
Cc: martyn.welch@ge.com, devel@driverdev.osuosl.org, manohar.vanga@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: =?utf-8?B?UEFUQ0hbW3ZtZS9icmlkZ2VzL3Zt?=
 =?utf-8?B?ZV9jYTkxY3g0Mi5jOjEzODI6IEJhZCBpZiB0ZXN0IEJ1ZyBGaXhd4oCP4oCP?=
Message-ID: <20140612205208.GY5015@mwanda>
References: <BLU436-SMTP2404B87A72E455C1BDE2B43A52A0@phx.gbl>
 <20140612151037.GU5500@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612151037.GU5500@mwanda>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martyn,

Nick Krause emailed me privately that he's not able to get git to work.
Normally for bug fixes, we would patch this up ourselves.

The offending code was introduced in:

commit 2b82beb8c1bc81b3dde69d16cacbc22546681acf
Author: Martyn Welch <martyn.welch@ge.com>
Date:   Thu Feb 18 15:13:19 2010 +0000

    Staging: vme: Add location monitor support for ca91cx42

The |= 0 does look very suspicious and I have a static checker warning
for code like that.  Certainly it sounds very authoritative to say that
instead of zero, CA91CX42_LM_CTL_AS_A16 should be (3 << 16).  But then
the condition:

	if ((lm_ctl & (5 << 16)) == (3 << 16))

is always false...  It is puzzling.

I don't know this code and I have no idea what is correct.  Was this a
real bug that Nick hit in testing, or was it a static checker fix?  He
hasn't told us any of this stuff...

What to do...

regards,
dan carpenter

