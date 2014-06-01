Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaFAOY2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 10:24:28 -0400
Received: from senator.holtmann.net ([87.106.208.187]:33919 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaFAOY0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 10:24:26 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.2\))
Subject: Re: [PATCH] net: bluetooth: hci_core.c:  Cleaning up uninitialized variables
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <1401631076-20818-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Date: Sun, 1 Jun 2014 16:24:21 +0200
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <AB19A214-D495-44EE-87E0-45332F156767@holtmann.org>
References: <1401631076-20818-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
X-Mailer: Apple Mail (2.1878.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rickard,

> There is a risk that the variable will be used without being initialized.
> 
> This was largely found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
> net/bluetooth/hci_core.c |    2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> index 1c6ffaa..1d93d2f 100644
> --- a/net/bluetooth/hci_core.c
> +++ b/net/bluetooth/hci_core.c
> @@ -4603,7 +4603,7 @@ static struct hci_chan *hci_chan_sent(struct hci_dev *hdev, __u8 type,
> 	struct hci_chan *chan = NULL;
> 	unsigned int num = 0, min = ~0, cur_prio = 0;
> 	struct hci_conn *conn;
> -	int cnt, q, conn_num = 0;
> +	int cnt, q = 0, conn_num = 0;

I have no idea on how the variable will be used without being initialized. Have you actually looked through that function. The only thing we do with q is assign it and then use it. That is it.

Regards

Marcel

