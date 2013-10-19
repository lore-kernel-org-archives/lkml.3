Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab3JSLiq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 07:38:46 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:62544 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3JSLio convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 07:38:44 -0400
MIME-Version: 1.0
Date: Sat, 19 Oct 2013 08:38:43 -0300
Message-ID: <CAGG-pUTXC+6O-wyYp0FZxKH-XWqP++jLEn-Km5kixQFcKsWRZA@mail.gmail.com>
Subject: net: sctp: possible dereference after freeing
From: =?UTF-8?Q?Geyslan_Greg=C3=B3rio_Bem?= <geyslan@gmail.com>
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi maintainers,

I would like to know if these are catches:

/net/sctp/endpointola.c (281)
static void sctp_endpoint_destroy(struct sctp_endpoint *ep)
{
    struct sock *sk;
...
    kfree(ep);
    SCTP_DBG_OBJCNT_DEC(ep);
}

The 'ep' object counter is being decremented?! Is the kfree to be there indeed?
Let me know what was intended here.

Same here:
/net/sctp/endpointola.c (165)
static void sctp_transport_destroy_rcu(struct rcu_head *head)
{
    struct sctp_transport *transport;
...
    kfree(transport);
    SCTP_DBG_OBJCNT_DEC(transport);
}

Regards,

Geyslan Gregório Bem
hackingbits.com
