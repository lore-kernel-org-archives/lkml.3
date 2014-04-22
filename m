Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbaDVIUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 04:20:08 -0400
Received: from smtp.sgsi.ucl.ac.be ([130.104.5.67]:33128 "EHLO
	smtp6.sgsi.ucl.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDVIT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 04:19:59 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Apr 2014 04:19:59 EDT
X-DKIM: Sendmail DKIM Filter v2.8.3 smtp6.sgsi.ucl.ac.be DF945183485
Date: Tue, 22 Apr 2014 10:14:19 +0200
From: Christoph Paasch <christoph.paasch@uclouvain.be>
To: Madhan <madhan.mepco@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tcp option added by driver
Message-ID: <20140422081419.GA5460@cpaasch-mac>
References: <d17085b0713540e88332f201d0296f69@UCL-MBX03.OASIS.UCLOUVAIN.BE>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d17085b0713540e88332f201d0296f69@UCL-MBX03.OASIS.UCLOUVAIN.BE>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Sgsi-Spamcheck: SASL authenticated, 
X-SGSI-MailScanner-ID: DF945183485.A06C7
X-SGSI-MailScanner: Found to be clean
X-SGSI-From: christoph.paasch@uclouvain.be
X-SGSI-Spam-Status: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 22/04/14 - 05:27:55, Madhan wrote:
> hi ,
> Is it possible to update the option field of the tcp header dynamically by the driver rather than the change in tcp/ip stack .
> i.e Can i add a driver to implement mptcp rather than building entire kernel again ?

in principle it seems possible to do this at a driver-level. Alcatel-Lucent
implemented something similar using netfilter-hooks:
https://open-innovation.alcatel-lucent.com/projects/mptcp-proxy

Regular TCP was running on top, and the netfilter hooks allowed to
rewrite the TCP/IP header.


However, I think that doing it that way will be huge implementation effort
(considering that there exists already an open-source implementation at 
multipath-tcp.org) and it might be hard to achieve good performance and make it
scale properly.

You basically have to reimplement a full TCP-stack at the driver as each
TCP-subflow has to behave as regular TCP (3-way handshake, retransmissions,...)


Cheers,
Christoph

