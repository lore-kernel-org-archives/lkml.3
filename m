Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbaATIqL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:46:11 -0500
Received: from mail.SerNet.de ([193.175.80.2]:53836 "EHLO mail.SerNet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752569AbaATIqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:46:09 -0500
X-Greylist: delayed 1861 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 03:46:09 EST
Date: Mon, 20 Jan 2014 09:14:54 +0100
Date: Mon, 20 Jan 2014 09:14:54 +0100
From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
To: Pavel Shilovsky <piastry@etersoft.ru>
Cc: linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        wine-devel@winehq.org
Subject: Re: [PATCH v7 0/7] Add O_DENY* support for VFS and CIFS/NFS
Reply-To: Volker.Lendecke@SerNet.DE
References: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389953232-9428-1-git-send-email-piastry@etersoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-Id: <E1W5A0e-000MT9-A1@intern.SerNet.DE>
Organization: SerNet GmbH, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri, Jan 17, 2014 at 02:07:05PM +0400, Pavel Shilovsky wrote:
> If O_DENYDELETE flag is specified and the open succeded,
> any further unlink operation will fail with -ESHAREDENIED
> untill this open is closed. Now this flag is processed by
> VFS and CIFS filesystem. NFS returns -EINVAL for opens
> with this flag.

This looks really, really good, thanks!

One question: If Samba wants to open a file for delete
access, there's no corresponding flag in the open
permissions. There can be the case where Samba wants to open
*just* for future unlink, no read or write access required.
Is there a way to achieve this atomically correct?

Thanks,

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
