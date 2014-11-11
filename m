Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaKKLEf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:04:35 -0500
Received: from mga01.intel.com ([192.55.52.88]:34533 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaKKLEe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:04:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,360,1413270000"; 
   d="scan'208";a="620493119"
Message-ID: <1415703869.22887.132.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/4] UBIFS: Add xattr support for symlinks
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org, Subodh Nijsure <snijsure@grid-net.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Date: Tue, 11 Nov 2014 13:04:29 +0200
In-Reply-To: <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
	 <1414781431-2911-3-git-send-email-ben.shelton@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've pushed this patch to the master branch. But I did ab amendment.

On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> +static int __ubifs_setxattr(struct inode *host, const char *name,
> +			    const void *value, size_t size, int flags)
>  {

I renamed this to just 'setxattr()', to be consistent wit the rest of
the code where we use the following convention:

* non-static functions start with 'ubifs_'
* static functions use any name, and do not start with 'ubifs_'
* we just do not prefix functions with '__' anywhere, so let's not use
it in xattr.c either.

Artem.

