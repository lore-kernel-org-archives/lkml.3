Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758409Ab3CDS24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:28:56 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47889 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754493Ab3CDS2z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:28:55 -0500
Message-ID: <1362421733.1965.11.camel@joe-AO722>
Subject: Re: [PATCH 05/11] zcache: Make the debug code use pr_debug
From: Joe Perches <joe@perches.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, dan.magenheimer@oracle.com
Date: Mon, 04 Mar 2013 10:28:53 -0800
In-Reply-To: <1362421101-15896-6-git-send-email-konrad.wilk@oracle.com>
References: <1362421101-15896-1-git-send-email-konrad.wilk@oracle.com>
	 <1362421101-15896-6-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-04 at 13:18 -0500, Konrad Rzeszutek Wilk wrote:
> as if you are debugging this driver you would be using 'debug'
> on the command line anyhow - and this would dump the debug
> data on the proper loglevel.

Please add
#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
before any #includes and remove all the "zcache: "
prefixes from the pr_<level> uses.


> +	pr_debug("zcache: obj_count=%zd\n", zcache_obj_count);

just pr_debug("obj_count=%zd\n", zcache_obj_count);

etc.


