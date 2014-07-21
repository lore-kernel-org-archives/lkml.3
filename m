Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932386AbaGUN3N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 09:29:13 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:53908 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114AbaGUN3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 09:29:11 -0400
X-Greylist: delayed 845 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2014 09:29:11 EDT
Date: Mon, 21 Jul 2014 09:14:45 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Nick Krause <xerofoify@gmail.com>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: solos-pci.c: Fix me
Message-ID: <20140721091445.1ee700bb@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <CAPDOMVjnK=OF8mQrXbbgGUtCRJO8oG4+PQOETEcskNk=95GLrg@mail.gmail.com>
References: <CAPDOMVjnK=OF8mQrXbbgGUtCRJO8oG4+PQOETEcskNk=95GLrg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=0
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2014 00:59:42 -0400
Nick Krause <xerofoify@gmail.com> wrote:

> Hey Chas,
> There seems to be a fix me in this file in the function, solos_bh.
> Is the default statement correct and I remove the fix me or
> does it need to be rewritten.
> Cheers Nick
> 

I am afraid that I don't know enough about the solos hardware to know
if it needs to be rewritten.  I gather the solos returns at least three
kinds of packets, data, status and command.  If you wish to eliminate
the FIXME comment, you could just write:

@@ -850,8 +850,7 @@ static void solos_bh(unsigned long card_arg)
                                dev_kfree_skb_any(skb);
                                break;
 
-                       case PKT_COMMAND:
-                       default: /* FIXME: Not really, surely? */
+                       default: /* PKT_COMMAND */
                                if (process_command(card, port, skb))
                                        break;
                                spin_lock(&card->cli_queue_lock);

and be done with it since that will preserve existing behavior.
