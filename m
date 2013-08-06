Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3HFAvM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 20:51:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56632 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751570Ab3HFAvL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 20:51:11 -0400
Message-ID: <1375750269.1968.18.camel@joe-AO722>
Subject: Re: [PATCH] trivial: adjust code alignment
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, trivial@kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 05 Aug 2013 17:51:09 -0700
In-Reply-To: <20130805163054.GN5102@mwanda>
References: <1375714059-29567-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1375714059-29567-5-git-send-email-Julia.Lawall@lip6.fr>
	 <20130805160645.GI5051@mwanda> <1375719427.3133.31.camel@joe-AO722>
	 <20130805163054.GN5102@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 19:30 +0300, Dan Carpenter wrote:
> On Mon, Aug 05, 2013 at 09:17:07AM -0700, Joe Perches wrote:
> > ov7670_read via i2c_transfer can return a positive # too.
> > Perhaps all of these should be individually tested for "< 0".
> You're misreading something.  ov7670_read_i2c() only returns zero
> and negative error codes.

Yup, right, thanks, I skimmed over the

	if (ret >= 0) {
		...
		ret = 0;
	}

bit in ov7670_read_i2c

though I think this function via the i2c_transfer
can return 0 messages transferred as "success".


