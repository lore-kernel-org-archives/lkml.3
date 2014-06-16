Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932893AbaFPStS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 14:49:18 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34109 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932208AbaFPStR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 14:49:17 -0400
Date: Mon, 16 Jun 2014 21:49:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Stephan Gabert <stephan.gabert@fau.de>
Cc: pe1dnn@amsat.org, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, nicolas.pfeiffer@fau.de,
        linux-kernel@i4.cs.fau.de
Subject: Re: [PATCH 3/5] staging/wlags49_h2: correct check of the return
 value of register_netdev()
Message-ID: <20140616184903.GH5500@mwanda>
References: <1402930253-32537-1-git-send-email-stephan.gabert@fau.de>
 <1402930253-32537-4-git-send-email-stephan.gabert@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402930253-32537-4-git-send-email-stephan.gabert@fau.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 16, 2014 at 04:50:51PM +0200, Stephan Gabert wrote:
> As mentioned in net/core/dev.c register_netdev() explicitly returns a
> negative errno code on failure.
> 
> So in case of failure, one should rather test whether ret is negative
> than just unlike 0.

No.  In the kernel the normal way is to say:

	if (ret)
		return ret;

Zero is succes and non-zero is error code.

	if (ret != 0)
		return ret;

That's a double negative and pointlessly confusing.

	if (ret != 0 != 0 != 0)

That's a hextuple negative and awesomely confusing.

There are times where a double negative is ok.  When you are talking
about numbers specifically:

	if (ret != 0 && ret != 3) {

That means ret is not zero or three, but zero doesn't mean success or
failure, it's just a number.

For strcmp() functions you should always compare against zero
because that is the idiom.

	if (strcmp(foo, bar) < 0)
	if (strcmp(foo, bar) != 0)

The first "<" means "foo" is before "bar" and "!=" means not equal.

	if (ret < 0)
		return ret;

Probably means that now ret is either zero or a positive value???  It is
ambiguous.

regards,
dan carpenter

