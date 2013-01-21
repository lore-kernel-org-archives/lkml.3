Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3AUMHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:07:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753153Ab3AUMHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:07:35 -0500
Date: Mon, 21 Jan 2013 13:07:20 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/15] drivers/net/wireless/iwlegacy/4965-mac.c: adjust
 duplicate test
Message-ID: <20130121120719.GB5424@redhat.com>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
 <1358773378-4700-7-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358773378-4700-7-git-send-email-Julia.Lawall@lip6.fr>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 21, 2013 at 02:02:50PM +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete successive tests to the same location.  This looks like simple code
> duplication.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @s exists@
> local idexpression y;
> expression x,e;
> @@
> 
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>  { ... when forall
>    return ...; }
> ... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
>     when != \(XT_GETPAGE(...,y)\|WMI_CMD_BUF(...)\)
> *if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
>  { ... when forall
>    return ...; }
> // </smpl>
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

ACK

