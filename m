Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbaKSOsl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 09:48:41 -0500
Received: from senator.holtmann.net ([87.106.208.187]:56330 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaKSOsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 09:48:40 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: [PATCH v2] l2cap_core: automatically flushable packets aren't allowed on LE links
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1416408077-26514-1-git-send-email-stevenrwalter@gmail.com>
Date: Wed, 19 Nov 2014 22:48:25 +0800
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C7C04F3A-EC21-4E71-9550-68E50901947D@holtmann.org>
References: <106789BA-48C0-4428-BE3E-D0737F7A0641@holtmann.org> <1416408077-26514-1-git-send-email-stevenrwalter@gmail.com>
To: Steven Walter <stevenrwalter@gmail.com>
X-Mailer: Apple Mail (2.1993)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

you need to prefix the subject line with Bluetooth: like all other patches do.

> On Nov 19, 2014, at 22:41, Steven Walter <stevenrwalter@gmail.com> wrote:
> 
> The bluetooth spec states that automatically flushable packets may not
> be sent over a LE-U link.
> 
> Signed-off-by: Steven Walter <stevenrwalter@gmail.com>
> ---
> net/bluetooth/l2cap_core.c | 7 ++++---
> 1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
> index 4af3821..028fcc6 100644
> --- a/net/bluetooth/l2cap_core.c
> +++ b/net/bluetooth/l2cap_core.c
> @@ -764,7 +764,7 @@ static void l2cap_send_cmd(struct l2cap_conn *conn, u8 ident, u8 code, u16 len,
> 	if (!skb)
> 		return;
> 
> -	if (lmp_no_flush_capable(conn->hcon->hdev))
> +	if (lmp_no_flush_capable(conn->hcon->hdev) || (conn->hcon->type == LE_LINK))

no need for ( ) around that new statement.

> 		flags = ACL_START_NO_FLUSH;
> 	else
> 		flags = ACL_START;
> @@ -798,8 +798,9 @@ static void l2cap_do_send(struct l2cap_chan *chan, struct sk_buff *skb)
> 		return;
> 	}
> 
> -	if (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
> -	    lmp_no_flush_capable(hcon->hdev))
> +	if ((hcon->type == LE_LINK) ||

Same here, the ( ) are not needed.

> +	    (!test_bit(FLAG_FLUSHABLE, &chan->flags) &&
> +	    lmp_no_flush_capable(hcon->hdev)))
> 		flags = ACL_START_NO_FLUSH;
> 	else
> 		flags = ACL_START;

I wonder actually if we should have a helper function or add comments to explain why we are doing it this complicated.

Regards

Marcel

