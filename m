Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499AbaLDOL5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:11:57 -0500
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:51429 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaLDOL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:11:56 -0500
X-Greylist: delayed 346 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Dec 2014 09:11:55 EST
Date: Thu, 4 Dec 2014 09:05:47 -0500
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: nick <xerofoify@gmail.com>, Guy Ellis <guy@traverse.com.au>
Cc: linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: FIXME in solos-pci.c
Message-ID: <20141204090547.21fedeb9@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <547FDBF6.5020008@gmail.com>
References: <547FDBF6.5020008@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-0.001
X-NRLCMF-Virus-Scanned: No virus found
X-NRLCMF-Languages: en
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last I heard on this topic was from Guy Ellis,

	From: Guy Ellis <guy@traverse.com.au>
	To: linux-atm-general@lists.sourceforge.net
	Subject: Re: [Linux-ATM-General] solos-pci.c: Fix me
	Date: Tue, 22 Jul 2014 07:34:30 +1000

	Hi Chas/Nick,

	I think the FIXME is reminder to deal correctly with an unknown command.
	At the moment an unknown command is treated as a PKT_COMMAND which is 
	incorrect.
	I think the correct behaviour would be to ignore unknown commands and 
	just free the skb.

	That said I doubt this condition ever occurs, which is probably why it 
	has been this way since day 1.

	Nathan is on vacation at the moment, when he gets back in August I'll 
	ask him to tidy this up.

So perhaps, Guy could let us know if he had a chance for Nathan to
look at removing this FIXME.


On Wed, 03 Dec 2014 22:58:46 -0500
nick <xerofoify@gmail.com> wrote:

> Greetings Chas,
> I am wondering if there is any reason for the FIXME message in the below code. This is due to after reading the other parts of the function the code and logical seem similar and correct unless I am missing something about the hardware.
> Cheers Nick 
>  case PKT_COMMAND:
>                        default: /* FIXME: Not really, surely? */
>                               if (process_command(card, port, skb))
>                                         break;
>                                spin_lock(&card->cli_queue_lock);
>                                if (skb_queue_len(&card->cli_queue[port]) > 10) {
>                                      if (net_ratelimit())
>                                                 dev_warn(&card->dev->dev, "Dropping console response on port %d\n",
>                                                          port);
>                                         dev_kfree_skb_any(skb);
>                                 } else
>                                          skb_queue_tail(&card->cli_queue[port], skb);
>                                spin_unlock(&card->cli_queue_lock);
>                                break;
>                        }
>  
> 

