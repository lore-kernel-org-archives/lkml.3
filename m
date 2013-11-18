Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333Ab3KRHxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 02:53:55 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:36505 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab3KRHxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 02:53:44 -0500
Message-ID: <1384761220.30084.9.camel@linux-fkkt.site>
Subject: Re: [RFC] drivers/scsi/dc395x.c - msgin_qtag()
From: Oliver Neukum <oliver@neukum.org>
To: Geyslan =?ISO-8859-1?Q?Greg=F3rio?= Bem <geyslan@gmail.com>
Cc: Ali Akcaagac <aliakc@web.de>, Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        hch@infradead.org
Date: Mon, 18 Nov 2013 08:53:40 +0100
In-Reply-To: <CAGG-pUSG0sngtW_F3j=Koa1KmjsLKE-2RU9Jy5Zm_=eUoe5rOg@mail.gmail.com>
References: <CAGG-pUSG0sngtW_F3j=Koa1KmjsLKE-2RU9Jy5Zm_=eUoe5rOg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-15 at 17:53 -0200, Geyslan Gregório Bem wrote:

Hi,

> Hi guys,
> 
> In the function msgin_qtag() [line 2632], this dereference was intentional?
> 
> static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
>         struct DeviceCtlBlk *dcb, u8 tag)
> {
>     struct ScsiReqBlk *srb = NULL;
>     struct ScsiReqBlk *i;
>     dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
>            srb->cmd, tag, srb);
> ...
> 
> There is a srb (NULL) dereference in the dprintkdbg() parameteres.

That is a bad bug.

> If not, what approach do you suggest me for a patch?

Merge it with
        dprintkdbg(DBG_0, "msgin_qtag: (0x%p) <%02i-%i>\n",
                srb->cmd, srb->dcb->target_id, srb->dcb->target_lun);
later in the function.

	Regards
		Oliver


