Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345AbaDVLVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:21:53 -0400
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:33411 "EHLO
	smtp6.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096AbaDVLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:21:51 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp6.sgsi.ucl.ac.be 69B9A1C5602
Date: Tue, 22 Apr 2014 13:21:44 +0200
From: Christoph Paasch <christoph.paasch@uclouvain.be>
To: Rishi Madhan <rishi.madhan@gmail.com>
Cc: Madhan <madhan.mepco@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tcp option added by driver
Message-ID: <20140422112144.GE5460@cpaasch-mac>
References: <d17085b0713540e88332f201d0296f69@UCL-MBX03.OASIS.UCLOUVAIN.BE>
 <20140422081419.GA5460@cpaasch-mac>
 <0fe153ade3744537ba78651580ae8444@UCL-MBX03.OASIS.UCLOUVAIN.BE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fe153ade3744537ba78651580ae8444@UCL-MBX03.OASIS.UCLOUVAIN.BE>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: 69B9A1C5602.AEF2C
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/04/14 - 10:00:43, Rishi Madhan wrote:
> >You basically have to reimplement a full TCP-stack at the driver as each
> >TCP-subflow has to behave as regular TCP (3-way handshake, retransmissions,...)
> Can it be done like the usb modem driver ? Like adding the NCM or QMI or RNDIS header on the data field .
> Rather than changing the entire tcp header in the driver level .

I don't know exactly what the usb modem driver does, but for MPTCP it is
much more complex than just adding some bits to a segment.

> In case of mptcp  only the option field has to be changed . 

And the TCP/IP-header as you want to send your traffic via different paths. 

> And instead of sending the mptcp flags (such as mp_cap ,mp_join)
> inside option . Can it be done on the data ?

Then, this would be a whole new protocol, no more MPTCP. That's a different
story, and the idea of putting everything inside the data instead of the
TCP-option space has been widely discussed at the IETF, but got rejected
because of deadlock-issues with such an approach.

> The main reason why i am tryin to implement in this way is the effect of the MIDDLEBOX . 

What do you mean by the effect of the middlebox?


Btw., I'm not sure if lkml is the right place to discuss this. Maybe
move the discussion to mptcp-dev.


Cheers,
Christoph


> and also that server need not
> rebuild kernel (most of them dont want to also)  and can dynamically load/unload driver on need basis .
> 
> Regards,
> Madhan
> 
> On Tue, Apr 22, 2014 at 1:44 PM, Christoph Paasch <christoph.paasch@uclouvain.be<mailto:christoph.paasch@uclouvain.be>> wrote:
> Hello,
> 
> On 22/04/14 - 05:27:55, Madhan wrote:
> > hi ,
> > Is it possible to update the option field of the tcp header dynamically by the driver rather than the change in tcp/ip stack .
> > i.e Can i add a driver to implement mptcp rather than building entire kernel again ?
> 
> in principle it seems possible to do this at a driver-level. Alcatel-Lucent
> implemented something similar using netfilter-hooks:
> https://open-innovation.alcatel-lucent.com/projects/mptcp-proxy
> 
> Regular TCP was running on top, and the netfilter hooks allowed to
> rewrite the TCP/IP header.
> 
> 
> However, I think that doing it that way will be huge implementation effort
> (considering that there exists already an open-source implementation at
> multipath-tcp.org<http://multipath-tcp.org>) and it might be hard to achieve good performance and make it
> scale properly.
> 
> You basically have to reimplement a full TCP-stack at the driver as each
> TCP-subflow has to behave as regular TCP (3-way handshake, retransmissions,...)
> 
> 
> Cheers,
> Christoph
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.kernel.org>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
