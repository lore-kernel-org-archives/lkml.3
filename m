Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261AbaJWRa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 13:30:58 -0400
Received: from mailsec111.isp.belgacom.be ([195.238.20.107]:29039 "EHLO
	mailsec111.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238AbaJWRa4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 13:30:56 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.1 cv=1oN0sfwJalOpr2aHay7Qy/p3C2/DrgK1QE5UNNaX0S8= c=1 sm=2
 a=IkcTkHD0fZMA:10 a=Dei6p5SHAAAA:8 a=jQWS32V1AT5XsqFMNk0A:9
 a=QEXdDO2ut3YA:10 a=ZaGerQNKEe0A:10
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AukKALA6SVTD7hTT/2dsb2JhbABcgw6EMrYRBpsyAoESFgF9hAIBAQEDASMEUgULBQQCGAICGA4CAlcGExGIKAyXRZxXhwCNWAEBAQcCAR+BLIR5igAzB4J3gVQFnw6DSYduiUWDejsvgksBAQE
Date: Thu, 23 Oct 2014 19:30:53 +0200 (CEST)
From: Fabian Frederick <fabf@skynet.be>
Reply-To: Fabian Frederick <fabf@skynet.be>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Message-ID: <20326343.74480.1414085453988.open-xchange@webmail.nmp.skynet.be>
In-Reply-To: <2F67F6E8-CA99-4998-AE68-89E60D62C39D@holtmann.org>
References: <1414081365-6461-1-git-send-email-fabf@skynet.be> <2F67F6E8-CA99-4998-AE68-89E60D62C39D@holtmann.org>
Subject: Re: [PATCH 1/1 net-next] Bluetooth: fix shadow warning in
 hci_disconnect()
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Priority: 3
Importance: Medium
X-Mailer: Open-Xchange Mailer v7.2.2-Rev27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 23 October 2014 at 18:29 Marcel Holtmann <marcel@holtmann.org> wrote:
>
>
> Hi Fabian,
>
> > use cpr for hci_cp_read_clock_offset instead of cp
> > (already defined above).
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
> > ---
> > net/bluetooth/hci_conn.c | 6 +++---
> > 1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
> > index b9517bd..6151e09 100644
> > --- a/net/bluetooth/hci_conn.c
> > +++ b/net/bluetooth/hci_conn.c
> > @@ -141,10 +141,10 @@ int hci_disconnect(struct hci_conn *conn, __u8 reason)
> >      */
> >     if (conn->type == ACL_LINK && conn->role == HCI_ROLE_MASTER) {
> >             struct hci_dev *hdev = conn->hdev;
> > -           struct hci_cp_read_clock_offset cp;
> > +           struct hci_cp_read_clock_offset cpr;
> >
> > -           cp.handle = cpu_to_le16(conn->handle);
> > -           hci_send_cmd(hdev, HCI_OP_READ_CLOCK_OFFSET, sizeof(cp), &cp);
> > +           cpr.handle = cpu_to_le16(conn->handle);
> > +           hci_send_cmd(hdev, HCI_OP_READ_CLOCK_OFFSET, sizeof(cpr), &cpr);
>
> valid change, but I do not like cpr as variable name. We need to come up with
> a better one. There are other places in the code where we had the same thing.
> Please have a look there.
>
> Regards
>
> Marcel
>

Hi Marcel,

  Maybe read_cp (like commit c1f23a2bfc89 with struct hci_cp_auth_requested
auth_cp) ?

Regards,
Fabian
