Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411AbaGCKMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 06:12:42 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.160]:58544 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261AbaGCKMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 06:12:39 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfssBY9SQMKk8kCovkkmJbh+VP2spQG3tvMeGW7W
X-RZG-CLASS-ID: mo00
Date: Thu, 3 Jul 2014 12:12:33 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 3.12 13/72] floppy: bail out in open() if drive is not
 responding to block0 read
Message-ID: <20140703101233.GA28675@aepfle.de>
References: <cover.1397812482.git.jslaby@suse.cz>
 <e6732e00c9ffc318d21fca56e747f59f85d078a1.1397812482.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e6732e00c9ffc318d21fca56e747f59f85d078a1.1397812482.git.jslaby@suse.cz>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 18, Jiri Slaby wrote:

> From: Jiri Kosina <jkosina@suse.cz>

> commit 7b7b68bba5ef23734c35ffb0d8d82079ed604d33 upstream.

> +static void floppy_rb0_cb(struct bio *bio, int err)
>  {
> -	complete((struct completion *)bio->bi_private);
> +	struct rb0_cbdata *cbdata = (struct rb0_cbdata *)bio->bi_private;
> +	int drive = cbdata->drive;
> +
> +	if (err) {
> +		pr_info("floppy: error %d while reading block 0", err);

This change lacks a newline...

Olaf
