Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbaLHUlA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 15:41:00 -0500
Received: from ja.ssi.bg ([178.16.129.10]:42844 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755240AbaLHUk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 15:40:59 -0500
Date: Mon, 8 Dec 2014 22:40:43 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Smart Weblications GmbH - Florian Wiessner 
	<f.wiessner@smart-weblications.de>
cc: Steffen Klassert <steffen.klassert@secunet.com>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org
Subject: Re: 3.12.33 - BUG xfrm_selector_match+0x25/0x2f6
In-Reply-To: <54858948.2060007@smart-weblications.de>
Message-ID: <alpine.LFD.2.11.1412082234350.2401@ja.home.ssi.bg>
References: <547F2462.6040405@smart-weblications.de> <20141204075627.GE6390@secunet.com> <alpine.LFD.2.11.1412042338370.4841@ja.home.ssi.bg> <5481173A.9060308@smart-weblications.de> <alpine.LFD.2.11.1412051126090.2522@ja.home.ssi.bg> <5481B944.2000002@smart-weblications.de>
 <alpine.LFD.2.11.1412072019410.1885@ja.home.ssi.bg> <54858948.2060007@smart-weblications.de>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	Hello,

On Mon, 8 Dec 2014, Smart Weblications GmbH - Florian Wiessner wrote:

> Am 07.12.2014 19:27, schrieb Julian Anastasov:>
> >
> > 	I'm attaching a patch that avoids rerouting in
> > IPVS for LOCAL_IN. Please test it in your setup. My tests
> > were with NAT on today's net tree. I checked that it
> > compiles for 3.12.33. You can use the default snat_reroute=1.
> >
> 
> I'm sorry to tell you that your patch does not fix the problem. The BUG happens
> as soon as the client sends PASV, the ftp server does not return "Entering
> Passive Mode":

	Patch is to avoid the xfrm_selector_match crash,
may be caused when using local client (mail?).
For nf_ct_seqadj_set you have to use commit b25adce16064
("ipvs: correct usage/allocation of seqadj ext in ipvs").
I'll send it to you privately...

Regards

--
Julian Anastasov <ja@ssi.bg>
