Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab3AOPL6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 10:11:58 -0500
Received: from eu1sys200aog104.obsmtp.com ([207.126.144.117]:38172 "EHLO
	eu1sys200aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757221Ab3AOPLz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 10:11:55 -0500
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ido Yariv <ido@wizery.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjur@brendeland.net>
Date: Tue, 15 Jan 2013 16:11:47 +0100
Subject: RE: [RFCv2 08/11] remoteproc: Refactor function
 rproc_elf_find_rsc_table
Thread-Topic: [RFCv2 08/11] remoteproc: Refactor function
 rproc_elf_find_rsc_table
Thread-Index: Ac3fIYH7T2rPjLz6RkyPMp2txtKEgwUDPMCw
Message-ID: <81C3A93C17462B4BBD7E272753C1057924588EE061@EXDCVYMBSTM005.EQ1STM.local>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-9-git-send-email-sjur.brandeland@stericsson.com>
 <20121221021839.GE28692@WorkStation.localnet>
In-Reply-To: <20121221021839.GE28692@WorkStation.localnet>
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

> > +static struct elf32_shdr *
> > +find_rsc_shdr(struct device *dev, struct elf32_hdr *ehdr)
> >  {
> > -	struct elf32_hdr *ehdr;
> >  	struct elf32_shdr *shdr;
> > +	int i;
> >  	const char *name_table;
> > -	struct device *dev = &rproc->dev;
> >  	struct resource_table *table = NULL;
> > -	int i;
> > -	const u8 *elf_data = fw->data;
> > +	const u8 *elf_data = (void *)ehdr;
> >
> > -	ehdr = (struct elf32_hdr *)elf_data;
> > +	/* look for the resource table and handle it */
> >  	shdr = (struct elf32_shdr *)(elf_data + ehdr->e_shoff);
> >  	name_table = elf_data + shdr[ehdr->e_shstrndx].sh_offset;
> >
> > -	/* look for the resource table and handle it */
> >  	for (i = 0; i < ehdr->e_shnum; i++, shdr++) {
> >  		int size = shdr->sh_size;
> >  		int offset = shdr->sh_offset;
> > @@ -249,12 +230,6 @@ rproc_elf_find_rsc_table(struct rproc *rproc, const
> struct firmware *fw,
> >
> >  		table = (struct resource_table *)(elf_data + offset);
> >
> > -		/* make sure we have the entire table */
> > -		if (offset + size > fw->size) {
> > -			dev_err(dev, "resource table truncated\n");
> > -			return NULL;
> > -		}
> > -
> 
> This should probably be kept in the internal function, since it
> dereferences the table as well. Moreover, this function will also be
> called from other function locations.

OK, I can do that.

> 
> It might also be a good idea to verify the offset as well, not just the
> size.

I'm not sure what you have in mind here. What sort of checks would you do on offset?

Regards,
Sjur
