Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab3FSQPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:15:07 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58587 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757010Ab3FSQPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:15:05 -0400
Message-ID: <1371658504.2038.25.camel@joe-AO722>
Subject: Re: [patch -next] FMC: NULL dereference on allocation failure
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alessandro Rubini <rubini@gnudd.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Date: Wed, 19 Jun 2013 09:15:04 -0700
In-Reply-To: <20130619160101.GA29108@mwanda>
References: <20130619160101.GA29108@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-19 at 19:01 +0300, Dan Carpenter wrote:
> If we don't allocate "arr" then the cleanup path will dereference it and
> oops.
[]
> diff --git a/drivers/fmc/fmc-sdb.c b/drivers/fmc/fmc-sdb.c
[]
> @@ -46,16 +46,17 @@ static struct sdb_array *__fmc_scan_sdb_tree(struct fmc_device *fmc,
[]
> -		arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
> -		arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);
[]
> +	arr->record = kzalloc(sizeof(arr->record[0]) * n, GFP_KERNEL);
> +	arr->subtree = kzalloc(sizeof(arr->subtree[0]) * n, GFP_KERNEL);

n comes from the hardware no?
Maybe make these kcalloc too.


