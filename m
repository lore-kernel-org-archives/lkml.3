Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab3AOPNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:13:55 -0500
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:57015 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756637Ab3AOPNy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:13:54 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 15 Jan 2013 16:13:45 +0100
Subject: RE: [RFCv2 09/11] remoteproc: Add operation to find resource table
 in memory
Thread-Topic: [RFCv2 09/11] remoteproc: Add operation to find resource table
 in memory
Thread-Index: Ac3fIasOGv2nQAFCThG1DgbyZQRvzwPOF4nw
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE066@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-10-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021948.GF28692@WorkStation.localnet>
In-Reply-To: <20121221021948.GF28692@WorkStation.localnet>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ido,

> From: Ido Yariv [mailto:ido@wizery.com]
> > +struct resource_table *rproc_elf_get_rsctab_addr(struct rproc *rproc,
> > +						 const struct firmware *fw)
> > +{
> > +	struct elf32_shdr *shdr;
> > +
> > +	shdr = find_rsc_shdr(&rproc->dev, (struct elf32_hdr *)fw->data);
> > +	if (!shdr)
> > +		return NULL;
> 
> Instead of traversing the headers twice, perhaps we could save the
> address and size in advance and use it here?

To do that we would have to store the struct elf32_shdr in struct rproc.
So this is a trade-off between bloating rproc structure with shdr or 
spending some more cpu-cycles to scan the elf sections.
It shouldn't be that many sections to scan, and as we've just parsed
this firmware sections earlier so it might be hot in cache.
This shouldn't be very expensive, so I'd prefer to keep this as is.

Are you OK with that?

Regards,
Sjur
