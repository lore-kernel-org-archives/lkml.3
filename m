Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab3CNGbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 02:31:46 -0400
Received: from mga03.intel.com ([143.182.124.21]:44787 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753781Ab3CNGbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 02:31:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,843,1355126400"; 
   d="scan'208";a="214460647"
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: RE: [ 031/100] iwlwifi: always copy first 16 bytes of commands
Thread-Topic: [ 031/100] iwlwifi: always copy first 16 bytes of commands
Thread-Index: AQHOH3GeO9ISapYnpEi55qFM8yBWfpikbakAgAAEOgCAAElzYA==
Date: Thu, 14 Mar 2013 06:31:36 +0000
Message-ID: <1DC40B07CD6EC041A66726C271A73AE61966F227@IRSMSX102.ger.corp.intel.com>
References: <20130312223122.884099393@linuxfoundation.org>
	 <20130312223126.381565711@linuxfoundation.org>
	 <1363225816.3937.119.camel@deadeye.wl.decadent.org.uk>
 <1363226724.3937.123.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1363226724.3937.123.camel@deadeye.wl.decadent.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r2E6VkOU028111

> > >  	/* and copy the data that needs to be copied */
> > >  	cmd_pos = offsetof(struct iwl_device_cmd, payload);
> > > +	copy_size = sizeof(out_cmd->hdr);
> > >  	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
> > > -		if (!cmd->len[i])
> > > +		int copy = 0;
> > > +
> > > +		if (!cmd->len)
> > >  			continue;
> >
> > cmd->len is an array, so the new condition is always false.  Shouldn't
> > it be 'if (!cmdlen[i])'?
> 
> To answer myself: no, it should still be 'if (!cmd->len[i])' as this loop needs to
> include input fragments that will be completely copied into the header
> fragment.

Ick, good catch. It luckily doesn't matter as if cmd->len[i] is 0 (in which case we'd continue) the "if (copy)" below saves us in all the different code paths inside the loop. This is still clearly a mistake in the patch though.

I will fix this upstream, I guess you'll want to wait for that for stable? I'll Cc:stable that patch as well.

johannes

Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Christian Lamprechter, Hannes Schwaderer, Douglas Lusk
Registergericht: Muenchen HRB 47456
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
