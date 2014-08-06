Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbaHFPJ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 11:09:27 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:49754 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbaHFPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 11:09:25 -0400
Message-Id: <1407337757.772491.149802333.5E523CB0@webmail.messagingengine.com>
X-Sasl-Enc: DbOB6Z813vjZTyIfya97cWaRchsCl+MG5RRpJDv8hlsJ 1407337757
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Koehrer Mathias <mathias.koehrer@etas.com> (ETAS/ESW5),
        Nick Krause <xerofoify@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
X-Mailer: MessagingEngine.com Webmail Interface - ajax-36a9b403
In-Reply-To: <53E23BEF.9030701@cogentembedded.com>
References: <be459158bb5c46fcaf73129858342da4@FE-MBX1012.de.bosch.com>
 <53E23BEF.9030701@cogentembedded.com>
Subject: Re: [PATCH] Fix e1000e with Intel 82572EI that has no hardware timestamp
 support
Date: Wed, 06 Aug 2014 12:09:17 -0300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 6, 2014, at 11:30, Sergei Shtylyov wrote:
> On 8/6/2014 6:27 PM, Koehrer Mathias (ETAS/ESW5) wrote:
> 
> > With the Intel 82527EI (driver: e1000e) there is an issue when running
> > the ptpd2 program, that leads to a kernel oops.
> > The reason is here that in e1000_xmit_frame() a work queue will be
> > scheduled that has not been initialized in this case.
> > The work queue "tx_hwstamp_work" will only be initialized if
> > adapter->flags & FLAG_HAS_HW_TIMESTAMP set.
> > This check is missing in e1000_xmit_frame().
> 
> > The following patch adds the missing check.
> 
>     OK, but this time you forgot your sign-off. :-)

Also, shouldn't the added test be inside the unlikely() ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
