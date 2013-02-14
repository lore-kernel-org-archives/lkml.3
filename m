Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3BNH16 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:27:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:33052 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab3BNH1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:27:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,662,1355126400"; 
   d="scan'208";a="287083345"
Message-ID: <1360826890.12703.158.camel@sauron.fi.intel.com>
Subject: Re: [PATCH RFC 4/5] UBIFS: Add security.* XATTR support for the
 UBIFS
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>
Date: Thu, 14 Feb 2013 09:28:10 +0200
In-Reply-To: <1360750998-15191-5-git-send-email-mkl@pengutronix.de>
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>
	 <1360750998-15191-5-git-send-email-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 11:23 +0100, Marc Kleine-Budde wrote:
> --- a/fs/ubifs/journal.c
> +++ b/fs/ubifs/journal.c
> @@ -553,7 +553,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const struct inode *dir,
>  
>         dbg_jnl("ino %lu, dent '%.*s', data len %d in dir ino %lu",
>                 inode->i_ino, nm->len, nm->name, ui->data_len, dir->i_ino);
> -       ubifs_assert(dir_ui->data_len == 0);
> +       if (!xent)
> +               ubifs_assert(dir_ui->data_len == 0);

Shouldn't this snippet be in 2/5 instead?

-- 
Best Regards,
Artem Bityutskiy

