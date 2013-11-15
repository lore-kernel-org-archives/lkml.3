Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3KOTxa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 14:53:30 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51422 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab3KOTx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 14:53:26 -0500
MIME-Version: 1.0
Date: Fri, 15 Nov 2013 17:53:25 -0200
Message-ID: <CAGG-pUSG0sngtW_F3j=Koa1KmjsLKE-2RU9Jy5Zm_=eUoe5rOg@mail.gmail.com>
Subject: [RFC] drivers/scsi/dc395x.c - msgin_qtag()
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <JBottomley@parallels.com>, dc395x@twibble.org
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        hch@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

In the function msgin_qtag() [line 2632], this dereference was intentional?

static struct ScsiReqBlk *msgin_qtag(struct AdapterCtlBlk *acb,
        struct DeviceCtlBlk *dcb, u8 tag)
{
    struct ScsiReqBlk *srb = NULL;
    struct ScsiReqBlk *i;
    dprintkdbg(DBG_0, "msgin_qtag: (0x%p) tag=%i srb=%p\n",
           srb->cmd, tag, srb);
...

There is a srb (NULL) dereference in the dprintkdbg() parameteres.

If not, what approach do you suggest me for a patch?

-- 
Regards,

Geyslan G. Bem
hackingbits.com
